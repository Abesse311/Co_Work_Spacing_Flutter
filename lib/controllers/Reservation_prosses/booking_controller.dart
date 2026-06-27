import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/variable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class BookingController extends GetxController {
  final Map<String, dynamic> room;
  BookingController({required this.room});

  // ── Booking Types ──────────────────────────────────────────────────────
  final bookingTypes = <Map<String, dynamic>>[].obs;
  final selectedBookingType = Rxn<Map<String, dynamic>>();
  final isLoadingTypes = true.obs;

  // ── Occupied data ──────────────────────────────────────────────────────
  /// Dates that are FULLY blocked → shown red/disabled on the calendar.
  final occupiedDates = <DateTime>{}.obs;

  /// Raw per-day slot data from the API: "YYYY-MM-DD" → ["08:00", "09:00", ...]
  final occupiedSlotsPerDay = <String, List<String>>{}.obs;

  final isLoadingOccupied = false.obs;

  // ── Calendar state ─────────────────────────────────────────────────────
  final selectedDay = Rxn<DateTime>();
  final focusedDay = DateTime.now().obs;

  // ── Hourly time selection ──────────────────────────────────────────────
  /// Start times of every selected consecutive 1-hour range, in order.
  /// e.g. ['08:00', '09:00', '10:00'] means 08:00 → 11:00 is selected.
  final selectedSlots = <String>[].obs;

  // ── Half-day slot selection ────────────────────────────────────────────
  /// '08:00' = morning (08:00-14:00) | '14:00' = afternoon (14:00-20:00)
  final selectedHalfSlot = Rxn<String>();

  static const _storage = FlutterSecureStorage();

  /// All possible 1-hour slot start times for this room, generated dynamically
  /// from the location's opening_time and closing_time.
  /// e.g. opening=09:00, closing=18:00 → ['09:00', '10:00', ..., '18:00']
  List<String> get allHourlySlots {
    final openTime  = room['opening_time']  as String? ?? '08:00';
    final closeTime = room['closing_time'] as String? ?? '20:00';
    final slots     = <String>[];
    int   current   = timeToMinutes(openTime);
    final end       = timeToMinutes(closeTime);
    while (current <= end) {
      final h = (current ~/ 60).toString().padLeft(2, '0');
      final m = (current % 60).toString().padLeft(2, '0');
      slots.add('$h:$m');
      current += 60;
    }
    return slots;
  }

  // ── Half-day computed boundaries ──────────────────────────────────────
  /// The location's opening time (morning slot start).
  String get halfDayOpenTime  => room['opening_time'] as String? ?? '08:00';

  /// The mid-point between open and close (half-day boundary).
  /// Falls back to the arithmetic midpoint if mid_time is not supplied.
  String get halfDayMidTime {
    final mid = room['mid_time'] as String?;
    if (mid != null && mid.isNotEmpty) return mid;
    // Compute midpoint from open/close
    final openMin  = timeToMinutes(halfDayOpenTime);
    final closeMin = timeToMinutes(halfDayCloseTime);
    final midMin   = openMin + ((closeMin - openMin) ~/ 2);
    final h = (midMin ~/ 60).toString().padLeft(2, '0');
    final m = (midMin %  60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// The location's closing time (afternoon slot end).
  String get halfDayCloseTime => room['closing_time'] as String? ?? '20:00';

  // ── Type detection ─────────────────────────────────────────────────────
  bool get isWeekly {
    final type = selectedBookingType.value;
    if (type == null) return false;
    final name = (type['name'] as String? ?? '').toLowerCase();
    final duration = type['duration_minutes'] as int? ?? 0;
    return duration >= 1440 || name.contains('semaine') || name.contains('week');
  }

  bool get isHourly {
    final type = selectedBookingType.value;
    if (type == null) return false;
    final name = (type['name'] as String? ?? '').toLowerCase();
    final duration = type['duration_minutes'] as int? ?? 0;
    return duration <= 120 ||
        name.contains('heure') ||
        name.contains('hour') ||
        name.contains('1h');
  }

  bool get isHalfDay {
    final type = selectedBookingType.value;
    if (type == null) return false;
    final name = (type['name'] as String? ?? '').toLowerCase();
    final duration = type['duration_minutes'] as int? ?? 0;
    return name.contains('demi') ||
        name.contains('half') ||
        (duration > 120 && duration < 720 && !isWeekly);
  }

  // ── Confirm button enabled ─────────────────────────────────────────────
  bool get isConfirmEnabled {
    if (selectedDay.value == null) return false;
    if (isHourly) {
      if (selectedSlots.isEmpty) return false;
      // Safety guard: the full derived range must be conflict-free.
      return !isRangeConflicting(effectiveStartTime!, effectiveEndTime!);
    }
    if (isHalfDay) return selectedHalfSlot.value != null;
    return true;
  }

  // ── Derived start / end times ──────────────────────────────────────────
  /// The start_time to send to the API: start of the first selected range.
  String? get effectiveStartTime =>
      selectedSlots.isEmpty ? null : selectedSlots.first;

  /// The end_time to send to the API: end of the last selected range.
  /// Since each range label is a start-of-hour, the end = next slot.
  String? get effectiveEndTime {
    if (selectedSlots.isEmpty) return null;
    final idx = allHourlySlots.indexOf(selectedSlots.last);
    return (idx >= 0 && idx + 1 < allHourlySlots.length)
        ? allHourlySlots[idx + 1]
        : null;
  }

  // ── Range conflict helper ──────────────────────────────────────────────
  /// Returns true if ANY slot in [sMin, eMin) is already occupied on the
  /// selected day.  e.g. 08:00 → 10:00 checks 08:00 and 09:00 slots.
  bool isRangeConflicting(String start, String end) {
    final day = selectedDay.value;
    if (day == null) return false;
    final sMin = timeToMinutes(start);
    final eMin = timeToMinutes(end);
    for (final slot in allHourlySlots) {
      final slotMin = timeToMinutes(slot);
      if (slotMin >= sMin && slotMin < eMin) {
        if (isSlotOccupied(day, slot)) return true;
      }
    }
    return false;
  }

  // ── Slot helpers ───────────────────────────────────────────────────────
  /// Whether the given time slot is occupied for the selected day.
  /// Used for HOURLY-level checks (exact start-time match in the API list).
  bool isSlotOccupied(DateTime day, String time) {
    final slots = occupiedSlotsPerDay[_fmt(day)];
    return slots?.contains(time) ?? false;
  }

  /// Whether a HALF-DAY slot is occupied based on the occupied hourly slots for that day.
  ///
  /// Morning  slot covers openTime–midTime  (slotKey == halfDayOpenTime)
  /// Afternoon slot covers midTime–closeTime (slotKey == halfDayMidTime)
  ///
  /// When midTime falls mid-hour (e.g. 13:30), the backend may return the
  /// "boundary-hour" slot (e.g. "13:00") for BOTH a morning booking and an
  /// afternoon booking, since the 13:00–14:00 block overlaps both periods.
  /// Any fixed boundary at 13:30 will therefore cause a false positive for one range.
  ///
  /// Solution: exclude the boundary-hour slot from BOTH ranges by using
  ///   • Morning   → slots in  [openTime, floor(midTime))
  ///   • Afternoon → slots in  [ceil(midTime),  closeTime)
  ///
  /// When midTime IS on the hour (e.g. 14:00), floor == ceil == midTime, so the
  /// two ranges are contiguous with no gap — behaviour is identical to a simple split.
  bool isHalfDaySlotOccupied(DateTime day, String slotKey) {
    final occupiedList = occupiedSlotsPerDay[_fmt(day)];
    if (occupiedList == null || occupiedList.isEmpty) return false;

    final int midMin   = timeToMinutes(halfDayMidTime);
    final int openMin  = timeToMinutes(halfDayOpenTime);
    final int closeMin = timeToMinutes(halfDayCloseTime);

    // Floor: largest whole-hour ≤ midTime.  Ceil: smallest whole-hour ≥ midTime.
    final int midFloor = (midMin ~/ 60) * 60;
    final int midCeil  = midMin % 60 == 0 ? midMin : midFloor + 60;

    final bool isMorning = timeToMinutes(slotKey) < midMin;

    for (final occupied in occupiedList) {
      final int t = timeToMinutes(occupied);
      if (isMorning) {
        // Morning: only count slots that unambiguously fall before the boundary hour.
        if (t >= openMin && t < midFloor) return true;
      } else {
        // Afternoon: only count slots that unambiguously fall after the boundary hour.
        if (t >= midCeil && t < closeMin) return true;
      }
    }
    return false;
  }

  /// Whether a day is FULLY booked (calendar disabled predicate).
  bool isDayOccupied(DateTime day) {
    if (isHourly) {
      final occupied = occupiedSlotsPerDay[_fmt(day)] ?? [];
      // allHourlySlots includes the closing time as a sentinel (non-bookable),
      // so the max number of booked start-times = allHourlySlots.length - 1.
      return occupied.length >= allHourlySlots.length - 1;
    }
    if (isHalfDay) {
      return isHalfDaySlotOccupied(day, halfDayOpenTime) &&
          isHalfDaySlotOccupied(day, halfDayMidTime);
    }
    // Day / Week: standard set-based check.
    return occupiedDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  /// For week bookings: all 5 consecutive days must be free.
  bool isWeekAvailable(DateTime start) {
    for (int i = 0; i < 5; i++) {
      if (isDayOccupied(start.add(Duration(days: i)))) return false;
    }
    return true;
  }

  // ── Step 1: Fetch booking types ────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchBookingTypes();
  }

  Future<void> fetchBookingTypes() async {
    isLoadingTypes.value = true;
    try {
      final response = await http.get(
        Uri.parse('$ngrok_url/rooms/${room['id']}/booking-types'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        bookingTypes.value =
            data.map((e) => e as Map<String, dynamic>).toList();
        if (bookingTypes.length == 1) selectBookingType(bookingTypes.first);
      } else {
        AppSnackbar.error('Error', 'Failed to load booking types');
      }
    } catch (e) {
      AppSnackbar.error('Error', 'Connection error: $e');
    } finally {
      isLoadingTypes.value = false;
    }
  }

  // ── Step 2: User picks a booking type ──────────────────────────────────
  void selectBookingType(Map<String, dynamic> type) {
    selectedBookingType.value = type;
    _clearSelections();
    fetchOccupiedDates();
  }

  void _clearSelections() {
    selectedDay.value = null;
    selectedSlots.clear();
    selectedHalfSlot.value = null;
    occupiedDates.clear();
    occupiedSlotsPerDay.clear();
  }

  // ── Step 3: Load occupied data ─────────────────────────────────────────
  Future<void> fetchOccupiedDates() async {
    final type = selectedBookingType.value;
    if (type == null) return;

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) return;

    // We will query the API for occupied slots.
    // If we are in half-day mode, the backend's half-day overlap logic is buggy
    // (e.g. marking Morning occupied for a 13:00 booking). We bypass it by
    // fetching the granular HOURLY occupied slots and doing the math locally.
    int queryTypeId = type['id'];
    if (isHalfDay) {
      // For half-day, fetch the hourly occupied slots so we can do range-overlap
      // checks locally (avoids relying on the backend's half-day overlap logic).
      final hourlyType = bookingTypes.firstWhere(
        (t) {
          final name     = (t['name'] as String? ?? '').toLowerCase();
          final duration = t['duration_minutes'] as int? ?? 0;
          return name.contains('heure') ||
              name.contains('hour')     ||
              name.contains('1h')       ||
              (duration > 0 && duration <= 120);
        },
        orElse: () => type,
      );
      queryTypeId = hourlyType['id'];
    }

    isLoadingOccupied.value = true;
    try {
      // Request a wide window so the full calendar has correct availability data.
      // Without explicit dates the backend defaults to ~7 days, causing distant
      // dates to appear falsely available.
      final today   = DateTime.now();
      final endDate = DateTime(today.year, today.month + 18, today.day);
      final startStr = _fmt(today);
      final endStr   = _fmt(endDate);

      final response = await http.get(
        Uri.parse(
          '$ngrok_url/bookings/occupied-slots'
          '?room_id=${room['id']}&booking_type_id=$queryTypeId'
          '&start_date=$startStr&end_date=$endStr',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      // ignore: avoid_print
      print('[Booking] occupied-slots ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        _parseOccupiedResponse(decoded);
      } else {
        AppSnackbar.error('Error', 'Failed to load availability');
      }
    } catch (e) {
      AppSnackbar.error('Error', 'Connection error: $e');
    } finally {
      isLoadingOccupied.value = false;
    }
  }

  void _parseOccupiedResponse(dynamic decoded) {
    final rawDates = <DateTime>{};
    final rawSlots = <String, List<String>>{};

    if (decoded is Map<String, dynamic>) {

      // ── occupied_periods: [{start_date, end_date}, ...] ──────────────────
      // Used by daily / weekly bookings.
      final periods = decoded['occupied_periods'];
      if (periods is List) {
        for (final p in periods) {
          if (p is Map<String, dynamic>) {
            final s = _parseDateOnly(p['start_date']?.toString() ?? '');
            final e = _parseDateOnly(p['end_date']?.toString() ?? '');
            if (s != null && e != null) {
              for (int i = 0; i <= e.difference(s).inDays; i++) {
                rawDates.add(s.add(Duration(days: i)));
              }
            }
          } else if (p is String) {
            // Some backends send a flat list of date strings inside occupied_periods.
            _tryParseDate(p, rawDates);
          }
        }
      }

      // ── occupied_dates / dates: ["YYYY-MM-DD", ...] ──────────────────────
      // Alternate key names used by some backends for day/week bookings.
      for (final key in ['occupied_dates', 'dates']) {
        final list = decoded[key];
        if (list is List) {
          for (final d in list) {
            if (d is String) _tryParseDate(d, rawDates);
          }
        }
      }

      // ── occupied_slots: {"YYYY-MM-DD": ["HH:mm", ...], ...} ─────────────
      // Used by hourly / half-day bookings. The date key itself counts as
      // occupied for day/week checking purposes.
      final slotsMap = decoded['occupied_slots'];
      if (slotsMap is Map<String, dynamic>) {
        for (final entry in slotsMap.entries) {
          final dateStr = entry.key;
          final times = (entry.value as List<dynamic>?)
                  ?.map((t) => t.toString())
                  .toList() ??
              [];
          rawSlots[dateStr] = times;
          _tryParseDate(dateStr, rawDates);
        }
      }

    } else if (decoded is List) {
      // Root-level list: either plain date strings or objects.
      for (final item in decoded) {
        if (item is String) {
          _tryParseDate(item, rawDates);
        } else if (item is Map<String, dynamic>) {
          final d = item['date'] ??
              item['start_date'] ??
              item['slot'] ??
              item['booking_date'];
          if (d is String) _tryParseDate(d, rawDates);
        }
      }
    }

    occupiedSlotsPerDay.assignAll(rawSlots);
    occupiedDates.assignAll(rawDates);
  }

  // ── Step 4: Calendar day tap ───────────────────────────────────────────
  void onDayTapped(DateTime tapped, DateTime focused) {
    focusedDay.value = focused;
    // Reset selections when a new day is chosen.
    selectedSlots.clear();
    selectedHalfSlot.value = null;

    if (isWeekly) {
      if (isWeekAvailable(tapped)) selectedDay.value = tapped;
    } else {
      selectedDay.value = tapped;
    }
  }

  // ── Step 5a: Hourly range tap ──────────────────────────────────────────
  /// Called when the user taps a range card whose label starts at [startTime].
  ///
  /// Rules:
  ///  - Occupied slot → ignored.
  ///  - Already selected slot → clears entire selection.
  ///  - No selection yet → selects this slot.
  ///  - Adjacent to current selection (before or after) → extends selection.
  ///  - Non-adjacent free slot → clears old selection and starts fresh.
  void onHourlyRangeTapped(String startTime) {
    final day = selectedDay.value;
    if (day == null) return;

    // Occupied → do nothing.
    if (isSlotOccupied(day, startTime)) return;

    // Already selected → deselect (clear all).
    if (selectedSlots.contains(startTime)) {
      selectedSlots.clear();
      return;
    }

    // First selection.
    if (selectedSlots.isEmpty) {
      selectedSlots.add(startTime);
      return;
    }

    final firstIdx = allHourlySlots.indexOf(selectedSlots.first);
    final lastIdx  = allHourlySlots.indexOf(selectedSlots.last);
    final thisIdx  = allHourlySlots.indexOf(startTime);

    if (thisIdx == firstIdx - 1) {
      // Extend backwards.
      selectedSlots.insert(0, startTime);
    } else if (thisIdx == lastIdx + 1) {
      // Extend forwards.
      selectedSlots.add(startTime);
    } else {
      // Non-adjacent → restart selection with this slot.
      selectedSlots.value = [startTime];
    }
  }

  int timeToMinutes(String t) {
    final parts = t.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // ── Step 5b: Half-day slot tap ─────────────────────────────────────────
  void onHalfSlotTapped(String slotKey) {
    final day = selectedDay.value;
    if (day != null && isHalfDaySlotOccupied(day, slotKey)) {
      return; // Occupied (range-overlap check) — ignore.
    }
    selectedHalfSlot.value =
        selectedHalfSlot.value == slotKey ? null : slotKey;
  }

  // ── Step 6: Confirm reservation ────────────────────────────────────────
  Future<void> confirmReservation() async {
    if (!isConfirmEnabled) return;

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      AppSnackbar.error('Error', 'Not logged in');
      return;
    }

    final sel = selectedDay.value!;
    final type = selectedBookingType.value!;
    final unitPrice = (type['price'] ?? 0).toDouble();

    // For hourly: price = unitPrice × number of hours selected.
    // For all other types: the API price is already the total flat price.
    double totalPrice = unitPrice;
    if (isHourly && selectedSlots.isNotEmpty) {
      final hours =
          (timeToMinutes(effectiveEndTime!) -
              timeToMinutes(effectiveStartTime!)) /
          60;
      totalPrice = unitPrice * hours;
    }

    final typeName = TKeys.translateBookingType(type['name'] ?? 'Reservation');
    final dateStr = _fmt(sel);

    // Build display label and start/end times for the POST body.
    String endDateLabel = dateStr;
    String startTime;
    String endTime;

    if (isHourly) {
      startTime = effectiveStartTime!;
      endTime   = effectiveEndTime!;
      final hours = (timeToMinutes(endTime) - timeToMinutes(startTime)) ~/ 60;
      final hoursLabel = hours == 1 ? '1 hour' : '$hours hours';
      endDateLabel = '$dateStr\n$startTime → $endTime ($hoursLabel)';
    } else if (isHalfDay) {
      if (selectedHalfSlot.value == halfDayOpenTime) {
        startTime    = halfDayOpenTime;
        endTime      = halfDayMidTime;
        endDateLabel = '$dateStr\n$halfDayOpenTime – $halfDayMidTime';
      } else {
        startTime    = halfDayMidTime;
        endTime      = halfDayCloseTime;
        endDateLabel = '$dateStr\n$halfDayMidTime – $halfDayCloseTime';
      }
    } else if (isWeekly) {
      final end = sel.add(const Duration(days: 4));
      endDateLabel = '${_fmt(sel)} → ${_fmt(end)}';
      startTime = '08:00';
      endTime = '20:00';
    } else {
      startTime = '08:00';
      endTime = '20:00';
    }

    final roomName = room['name'] ?? '';
    final locationName = room['location'] ?? '';

    final confirmed = await Get.dialog<bool>(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Row(
                children: [
                  Image.asset(
                    'icons/BookingIcons/confirmbooking.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      TKeys.confirmBooking.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF254D35),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Divider
              Container(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 16),

              // Booking details card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6845).withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF2E6845).withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (locationName.isNotEmpty) ...[
                      _buildDetailRow(
                        label: TKeys.locationPrefix.tr,
                        value: locationName,
                        singleLine: true,
                        iconAsset: 'icons/BookingIcons/location.png',
                      ),
                      const SizedBox(height: 14),
                    ],
                    if (roomName.isNotEmpty) ...[
                      _buildDetailRow(
                        label: 'Room',
                        value: roomName,
                        iconAsset: 'icons/BookingIcons/room.png',
                      ),
                      const SizedBox(height: 14),
                    ],
                    _buildDetailRow(
                      label: TKeys.reservationTypePrefix.tr,
                      value: typeName,
                      iconAsset: 'icons/BookingIcons/type.png',
                    ),
                    const SizedBox(height: 14),
                    _buildDetailRow(
                      label: TKeys.reservationDatePrefix.tr,
                      value: endDateLabel,
                      iconAsset: 'icons/BookingIcons/date.png',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E6845).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF2E6845).withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'icons/BookingIcons/price.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                TKeys.priceLabel.tr,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF254D35),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${totalPrice.toStringAsFixed(0)} DZD',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E6845),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        TKeys.cancel.tr,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6845),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true) {
      await _sendReservation(
        typeId: type['id'] as int,
        date: dateStr,
        startTime: startTime,
        endTime: endTime,
        token: token,
      );
    }
  }

  Future<void> _sendReservation({
    required int typeId,
    required String date,
    required String startTime,
    required String endTime,
    required String token,
  }) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final response = await http.post(
        Uri.parse('$ngrok_url/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'booking_type_id': typeId,
          'date': date,
          'start_time': startTime,
          'end_time': endTime,
        }),
      );
      Get.back(); // close loading spinner

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success('Success', 'Reservation confirmed!');
        _clearSelections();
        await fetchOccupiedDates(); // refresh calendar
      } else {
        final resp = jsonDecode(response.body);
        String errorMsg = resp['detail'] ?? resp['error'] ?? 'Reservation failed';

        // Intercept and translate French/backend error messages to English.
        final lowerMsg = errorMsg.toLowerCase();
        if (lowerMsg.contains('téléphone') ||
            lowerMsg.contains('telephone') ||
            lowerMsg.contains('numéro') ||
            lowerMsg.contains('numero')) {
          errorMsg =
              'Please verify your phone number in settings before making a booking.';
        } else if (response.statusCode == 402 ||
            lowerMsg.contains('solde') ||
            lowerMsg.contains('insuffisant')) {
          errorMsg = 'Insufficient balance.';
        } else if (lowerMsg.contains('plage horaire') ||
            lowerMsg.contains('n\'est pas disponible') ||
            lowerMsg.contains('not available') ||
            lowerMsg.contains('chevauchement') ||
            lowerMsg.contains('overlap') ||
            lowerMsg.contains('already booked') ||
            lowerMsg.contains('déjà réserv')) {
          // Time-slot conflict – display a neutral bilingual-safe message.
          errorMsg = TKeys.slotUnavailable.tr;
        }

        AppSnackbar.error('Error', errorMsg);
      }
    } catch (e) {
      Get.back();
      AppSnackbar.error('Error', 'Connection error: $e');
    }
  }

  // ── Utility ────────────────────────────────────────────────────────────
  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _tryParseDate(String raw, Set<DateTime> target) {
    final d = _parseDateOnly(raw);
    if (d != null) target.add(d);
  }

  DateTime? _parseDateOnly(String raw) {
    try {
      // Handle both space and 'T' as the date/time separator (ISO 8601).
      // e.g. "2025-09-02", "2025-09-02 08:00:00", "2025-09-02T08:00:00"
      final datePart = raw.split(RegExp(r'[ T]')).first.trim();
      final p = datePart.split('-');
      if (p.length < 3) return null;
      return DateTime(
        int.parse(p[0]),
        int.parse(p[1]),
        int.parse(p[2]),
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required String iconAsset,
    Color? valueColor,
    FontWeight? valueFontWeight,
    bool singleLine = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              iconAsset,
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: singleLine ? 1 : null,
          overflow: singleLine ? TextOverflow.ellipsis : TextOverflow.visible,
          style: TextStyle(
            fontSize: 14,
            color: valueColor ?? Colors.black87,
            fontWeight: valueFontWeight ?? FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
