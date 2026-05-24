import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/Reservation_prosses/booking_controller.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class RoomBookingPage extends StatelessWidget {
  final Map<String, dynamic> room;
  const RoomBookingPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final BookingController c = Get.put(BookingController(room: room));

    return Scaffold(
      appBar: AppBar(title: Text('Reservation - ${room['name']}')),
      body: Obx(() {
        if (c.isLoadingTypes.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.bookingTypes.isEmpty) {
          return const Center(
            child: Text('No booking types available for this room.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type selector ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Choose a reservation type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 8,
                children:
                    c.bookingTypes.map((type) {
                      final isSel =
                          c.selectedBookingType.value?['id'] == type['id'];
                      final price = (type['price'] ?? 0).toDouble();
                      return GestureDetector(
                        onTap: () => c.selectBookingType(type),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSel ? AppTheme.primary : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color:
                                  isSel
                                      ? AppTheme.primary
                                      : Colors.grey.shade300,
                              width: 1.5,
                            ),
                            boxShadow:
                                isSel
                                    ? [
                                      BoxShadow(
                                        color: AppTheme.primary.withValues(
                                          alpha: 0.25,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Column(
                            children: [
                              Text(
                                type['name'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isSel ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${price.toStringAsFixed(0)} DZD',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSel ? Colors.white70 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // ── Calendar + Slots ───────────────────────────────────────
            if (c.selectedBookingType.value != null)
              Expanded(
                child: Obx(() {
                  if (c.isLoadingOccupied.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final isWeekly = c.isWeekly;
                  final rangeEnd =
                      isWeekly && c.selectedDay.value != null
                          ? c.selectedDay.value!.add(const Duration(days: 4))
                          : null;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Legend
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _legendDot(Colors.red.shade200),
                              const SizedBox(width: 6),
                              Text(
                                'Reserved',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                              _legendDot(AppTheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Selected',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (isWeekly) ...[
                                const SizedBox(width: 16),
                                _legendDot(
                                  AppTheme.primary.withValues(alpha: 0.2),
                                  border: AppTheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Week range',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Calendar
                        TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime.now().add(const Duration(days: 90)),
                          focusedDay: c.focusedDay.value,
                          selectedDayPredicate:
                              isWeekly
                                  ? null
                                  : (day) =>
                                      isSameDay(day, c.selectedDay.value),
                          rangeStartDay: isWeekly ? c.selectedDay.value : null,
                          rangeEndDay: rangeEnd,
                          enabledDayPredicate: (day) {
                            if (isWeekly) return c.isWeekAvailable(day);
                            return !c.isDayOccupied(day);
                          },
                          onDaySelected: (sel, foc) => c.onDayTapped(sel, foc),
                          onPageChanged: (foc) => c.focusedDay.value = foc,
                          // Disable calendar's built-in swipe gestures so the
                          // parent SingleChildScrollView handles scrolling.
                          // Month navigation still works via the arrow buttons.
                          availableGestures: AvailableGestures.none,
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            todayTextStyle: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            selectedDecoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            rangeHighlightColor: AppTheme.primary.withValues(
                              alpha: 0.15,
                            ),
                            rangeStartDecoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            rangeStartTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            rangeEndDecoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            rangeEndTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            withinRangeTextStyle: const TextStyle(
                              color: AppTheme.primaryDark,
                            ),
                            disabledTextStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryDark,
                            ),
                            weekendStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          calendarBuilders: CalendarBuilders(
                            disabledBuilder: (ctx, day, _) {
                              final occ = c.isDayOccupied(day);
                              return Container(
                                margin: const EdgeInsets.all(5),
                                decoration:
                                    occ
                                        ? BoxDecoration(
                                          color: Colors.red.shade50,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.red.shade200,
                                          ),
                                        )
                                        : null,
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color:
                                          occ
                                              ? Colors.red.shade300
                                              : Colors.grey.shade400,
                                      decoration:
                                          occ
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // ── Slot Picker (Hourly) ──────────────────────
                        if (c.isHourly && c.selectedDay.value != null)
                          _HourlySlotPicker(controller: c),

                        // ── Slot Picker (Half-day) ────────────────────
                        if (c.isHalfDay && c.selectedDay.value != null)
                          _HalfDaySlotPicker(controller: c),

                        const SizedBox(height: 100), // space for FAB
                      ],
                    ),
                  );
                }),
              ),
          ],
        );
      }),

      // ── Confirm button ─────────────────────────────────────────────────
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: ElevatedButton(
            onPressed: c.isConfirmEnabled ? c.confirmReservation : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Confirm Booking',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _legendDot(Color color, {Color? border}) => Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: border != null ? Border.all(color: border, width: 1.5) : null,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Hourly Slot Picker
// ─────────────────────────────────────────────────────────────────────────────
class _HourlySlotPicker extends StatelessWidget {
  final BookingController controller;
  const _HourlySlotPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.selectedDay.value!;
      final start = controller.selectedStartTime.value;
      final end = controller.selectedEndTime.value;


      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            // Title
            const Text(
              'The slots',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a start and an end time for your booking',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            // Slot grid
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  BookingController.allHourlySlots.map((time) {
                    final occupied = controller.isSlotOccupied(day, time);
                    final isStart = time == start;
                    final isEnd = time == end;

                    // Highlight slots between start and end
                    bool inRange = false;
                    if (start != null && end != null) {
                      final tMin = controller.timeToMinutes(time);
                      final sMin = controller.timeToMinutes(start);
                      final eMin = controller.timeToMinutes(end);
                      inRange = tMin >= sMin && tMin <= eMin;
                    }

                    Color bgColor;
                    Color textColor;
                    Color borderColor;

                    if (occupied) {
                      bgColor = Colors.red.shade50;
                      textColor = Colors.red.shade300;
                      borderColor = Colors.red.shade200;
                    } else if (isStart || isEnd) {
                      bgColor = AppTheme.primary;
                      textColor = Colors.white;
                      borderColor = AppTheme.primary;
                    } else if (inRange) {
                      bgColor = AppTheme.primary.withValues(alpha: 0.15);
                      textColor = AppTheme.primaryDark;
                      borderColor = AppTheme.primary.withValues(alpha: 0.4);
                    } else {
                      bgColor = Colors.white;
                      textColor = Colors.black87;
                      borderColor = Colors.grey.shade300;
                    }

                    return GestureDetector(
                      onTap:
                          occupied
                              ? null
                              : () => controller.onHourlySlotTapped(time),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 78,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                              decoration:
                                  occupied ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Half-day Slot Picker
// ─────────────────────────────────────────────────────────────────────────────
class _HalfDaySlotPicker extends StatelessWidget {
  final BookingController controller;
  const _HalfDaySlotPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.selectedDay.value!;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const Text(
              'The slots',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _halfDayCard(
                    context: context,
                    label: '🌅  Morning',
                    timeRange: '08:00 – 13:00',
                    slotKey: '08:00',
                    day: day,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _halfDayCard(
                    context: context,
                    label: '🌆  Afternoon',
                    timeRange: '13:00 – 20:00',
                    slotKey: '13:00',
                    day: day,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _halfDayCard({
    required BuildContext context,
    required String label,
    required String timeRange,
    required String slotKey,
    required DateTime day,
  }) {
    final occupied = controller.isSlotOccupied(day, slotKey);
    final isSelected = controller.selectedHalfSlot.value == slotKey;

    Color bgColor;
    Color borderColor;
    Color labelColor;
    Color timeColor;

    if (occupied) {
      bgColor = Colors.red.shade50;
      borderColor = Colors.red.shade200;
      labelColor = Colors.red.shade300;
      timeColor = Colors.red.shade200;
    } else if (isSelected) {
      bgColor = AppTheme.primary;
      borderColor = AppTheme.primary;
      labelColor = Colors.white;
      timeColor = Colors.white70;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
      labelColor = Colors.black87;
      timeColor = Colors.grey.shade600;
    }

    return GestureDetector(
      onTap: occupied ? null : () => controller.onHalfSlotTapped(slotKey),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: labelColor,
                decoration: occupied ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              timeRange,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: timeColor),
            ),
            if (occupied) ...[
              const SizedBox(height: 6),
              Text(
                'Reserved',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
