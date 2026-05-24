import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/variables.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  final selectedStartTime = Rxn<String>();
  final selectedEndTime = Rxn<String>();

  // ── Half-day slot selection ────────────────────────────────────────────
  /// '08:00' = morning (08:00-13:00) | '13:00' = afternoon (13:00-20:00)
  final selectedHalfSlot = Rxn<String>();

  static const _storage = FlutterSecureStorage();

  /// All possible 1-hour slots for the room (08:00 → 20:00 inclusive).
  static const List<String> allHourlySlots = [
    '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
    '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00',
  ];

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
      return selectedStartTime.value != null && selectedEndTime.value != null;
    }
    if (isHalfDay) return selectedHalfSlot.value != null;
    return true;
  }

  // ── Slot helpers ───────────────────────────────────────────────────────
  /// Whether the given time slot is occupied for the selected day.
  bool isSlotOccupied(DateTime day, String time) {
    final slots = occupiedSlotsPerDay[_fmt(day)];
    return slots?.contains(time) ?? false;
  }

  /// Whether a day is FULLY booked (calendar disabled predicate).
  bool isDayOccupied(DateTime day) {
    if (isHourly) {
      final occupied = occupiedSlotsPerDay[_fmt(day)] ?? [];
      return occupied.length >= allHourlySlots.length;
    }
    if (isHalfDay) {
      return isSlotOccupied(day, '08:00') && isSlotOccupied(day, '13:00');
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
        Get.snackbar('Error', 'Failed to load booking types');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection error: $e');
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
    selectedStartTime.value = null;
    selectedEndTime.value = null;
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

    isLoadingOccupied.value = true;
    try {
      final response = await http.get(
        Uri.parse(
          '$ngrok_url/bookings/occupied-slots'
          '?room_id=${room['id']}&booking_type_id=${type['id']}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      // ignore: avoid_print
      print('[Booking] occupied-slots ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        _parseOccupiedResponse(decoded);
      } else {
        Get.snackbar('Error', 'Failed to load availability');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection error: $e');
    } finally {
      isLoadingOccupied.value = false;
    }
  }

  void _parseOccupiedResponse(dynamic decoded) {
    final rawDates = <DateTime>{};
    final rawSlots = <String, List<String>>{};

    if (decoded is Map<String, dynamic>) {
      // Parse occupied_periods → add every date in each range.
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
          }
        }
      }

      // Parse occupied_slots → populate per-day slot map.
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
      for (final item in decoded) {
        if (item is String) {
          _tryParseDate(item, rawDates);
        } else if (item is Map<String, dynamic>) {
          final d = item['date'] ?? item['start_date'] ?? item['slot'];
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
    // Reset time/slot selections when a new day is chosen.
    selectedStartTime.value = null;
    selectedEndTime.value = null;
    selectedHalfSlot.value = null;

    if (isWeekly) {
      if (isWeekAvailable(tapped)) selectedDay.value = tapped;
    } else {
      selectedDay.value = tapped;
    }
  }

  // ── Step 5a: Hourly slot tap ───────────────────────────────────────────
  void onHourlySlotTapped(String time) {
    // Ignore occupied slots.
    if (selectedDay.value != null && isSlotOccupied(selectedDay.value!, time)) {
      return;
    }

    if (selectedStartTime.value == null) {
      // First tap → set start time.
      selectedStartTime.value = time;
      selectedEndTime.value = null;
    } else if (selectedEndTime.value == null) {
      // Second tap → set end time (must be after start).
      if (timeToMinutes(time) > timeToMinutes(selectedStartTime.value!)) {
        selectedEndTime.value = time;
      } else {
        // Tapped before/on start → re-select start.
        selectedStartTime.value = time;
      }
    } else {
      // Already have both → restart selection.
      selectedStartTime.value = time;
      selectedEndTime.value = null;
    }
  }

  int timeToMinutes(String t) {
    final parts = t.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // ── Step 5b: Half-day slot tap ─────────────────────────────────────────
  void onHalfSlotTapped(String slotKey) {
    if (selectedDay.value != null && isSlotOccupied(selectedDay.value!, slotKey)) {
      return; // Occupied — ignore.
    }
    selectedHalfSlot.value =
        selectedHalfSlot.value == slotKey ? null : slotKey;
  }

  // ── Step 6: Confirm reservation ────────────────────────────────────────
  Future<void> confirmReservation() async {
    if (!isConfirmEnabled) return;

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'Not logged in');
      return;
    }

    final sel = selectedDay.value!;
    final type = selectedBookingType.value!;
    final unitPrice = (type['price'] ?? 0).toDouble();

    // For hourly: price = unitPrice × number of hours selected.
    // For all other types: the API price is already the total flat price.
    double totalPrice = unitPrice;
    if (isHourly &&
        selectedStartTime.value != null &&
        selectedEndTime.value != null) {
      final hours =
          (timeToMinutes(selectedEndTime.value!) -
              timeToMinutes(selectedStartTime.value!)) /
          60;
      totalPrice = unitPrice * hours;
    }

    final typeName = type['name'] ?? 'Reservation';
    final dateStr = _fmt(sel);

    // Build display label and start/end times for the POST body.
    String endDateLabel = dateStr;
    String startTime;
    String endTime;

    if (isHourly) {
      startTime = selectedStartTime.value!;
      endTime = selectedEndTime.value!;
      endDateLabel = '$dateStr  $startTime → $endTime';
    } else if (isHalfDay) {
      if (selectedHalfSlot.value == '08:00') {
        startTime = '08:00';
        endTime = '13:00';
        endDateLabel = '$dateStr  Morning (08:00–13:00)';
      } else {
        startTime = '13:00';
        endTime = '20:00';
        endDateLabel = '$dateStr  Afternoon (13:00–20:00)';
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

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Reservation'),
        content: Text(
          'Type: $typeName\n'
          'Date: $endDateLabel\n'
          'Price: ${totalPrice.toStringAsFixed(2)} DZD\n\n'
          'Confirm this booking?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Confirm'),
          ),
        ],
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
        Get.snackbar(
          'Success',
          'Reservation confirmed!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _clearSelections();
        await fetchOccupiedDates(); // refresh calendar
      } else {
        final resp = jsonDecode(response.body);
        String errorMsg = resp['detail'] ?? resp['error'] ?? 'Reservation failed';

        // Intercept and translate French backend phone verification error message to English
        final lowerMsg = errorMsg.toLowerCase();
        if (lowerMsg.contains('téléphone') || lowerMsg.contains('telephone') || lowerMsg.contains('numéro') || lowerMsg.contains('numero')) {
          errorMsg = 'Please verify your phone number in settings before making a booking.';
        }

        Get.snackbar(
          'Error',
          errorMsg,
          backgroundColor: const Color(0xFFAA2213),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Connection error: $e');
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
      final datePart = raw.split(' ').first.trim();
      final p = datePart.split('-');
      return DateTime(
        int.parse(p[0]),
        int.parse(p[1]),
        int.parse(p[2]),
      );
    } catch (_) {
      return null;
    }
  }
}
