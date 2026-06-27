import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/Reservation_prosses/booking_controller.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class RoomBookingPage extends StatelessWidget {
  final Map<String, dynamic> room;
  const RoomBookingPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final BookingController c = Get.put(BookingController(room: room));

    return Scaffold(
      appBar: AppBar(title: Text('${TKeys.reservationTitle.tr}\n${room['name']}',maxLines: 2,)),
      body: Obx(() {
        if (c.isLoadingTypes.value) {
          return  Center(child: CircularProgressIndicator());
        }
        if (c.bookingTypes.isEmpty) {
          return  Center(
            child: Text(TKeys.noBookingTypes.tr),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type selector ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                TKeys.chooseReservationType.tr,
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
                          duration:  Duration(milliseconds: 200),
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
                                        offset:  Offset(0, 3),
                                      ),
                                    ]
                                    : [],
                          ),
                          child: Column(
                            children: [
                              Text(
                                TKeys.translateBookingType(type['name'] ?? ''),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isSel ? Colors.white : Colors.black87,
                                ),
                              ),
                               SizedBox(height: 2),
                              Text(
                                '${price.toStringAsFixed(0)} DZD',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

             SizedBox(height: 12),

            // ── Calendar + Slots ───────────────────────────────────────
            if (c.selectedBookingType.value != null)
              Expanded(
                child: Obx(() {
                  if (c.isLoadingOccupied.value) {
                    return  Center(child: CircularProgressIndicator());
                  }

                  // Explicitly read Rx variables to register Obx dependencies
                  final selectedDate = c.selectedDay.value;
                  final focusedDate = c.focusedDay.value;

                  final isWeekly = c.isWeekly;
                  final rangeEnd =
                      isWeekly && selectedDate != null
                          ? selectedDate.add( Duration(days: 4))
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
                               SizedBox(width: 6),
                              Text(
                                'Reserved',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                               SizedBox(width: 16),
                              _legendDot(AppTheme.primary),
                               SizedBox(width: 6),
                              Text(
                                'Selected',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (isWeekly) ...[
                                 SizedBox(width: 16),
                                _legendDot(
                                  AppTheme.primary.withValues(alpha: 0.2),
                                  border: AppTheme.primary,
                                ),
                                 SizedBox(width: 6),
                                Text(
                                  'Week range',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                         SizedBox(height: 8),

                        // Calendar
                        TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime(DateTime.now().year + 2, 12, 31),
                          focusedDay: focusedDate,
                          selectedDayPredicate:
                              isWeekly
                                  ? null
                                  : (day) =>
                                      isSameDay(day, selectedDate),
                          rangeStartDay: isWeekly ? selectedDate : null,
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
                            todayTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                            ) ??  TextStyle(),
                            selectedDecoration:  BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            selectedTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ) ??  TextStyle(),
                            rangeHighlightColor: AppTheme.primary.withValues(
                              alpha: 0.15,
                            ),
                            rangeStartDecoration:  BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            rangeStartTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ) ??  TextStyle(),
                            rangeEndDecoration:  BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                            rangeEndTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ) ??  TextStyle(),
                            withinRangeTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryDark,
                            ) ??  TextStyle(),
                            disabledTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                              fontSize: 13,
                            ) ??  TextStyle(),
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.primaryDark,
                            ) ??  TextStyle(),
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: AppTheme.primaryDark,
                            ) ??  TextStyle(),
                            weekendStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: Colors.grey,
                            ) ??  TextStyle(),
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
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

                         SizedBox(height: 100), // space for FAB
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
            child: Text(
              'Confirm Booking',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
// Hourly Slot Picker  (range-based: 12 cards, each card = 1 hour interval)
// ─────────────────────────────────────────────────────────────────────────────
class _HourlySlotPicker extends StatelessWidget {
  final BookingController controller;
  const _HourlySlotPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Slots are generated dynamically from the location's opening/closing time.
    final slots = controller.allHourlySlots;

    return Obx(() {
      final day = controller.selectedDay.value!;
      final selected = controller.selectedSlots;

      // Summary label shown below the grid when slots are chosen.
      String? summaryLabel;
      if (selected.isNotEmpty) {
        final s = controller.effectiveStartTime!;
        final e = controller.effectiveEndTime!;
        final hours =
            (controller.timeToMinutes(e) - controller.timeToMinutes(s)) ~/ 60;
        final label = hours == 1 ? '1 hour' : '$hours hours';
        summaryLabel = '$s → $e  ($label)';
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),

            // ── Title ───────────────────────────────────────────────────
            Text(
              'The slots',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap a slot to select it. Tap consecutive slots to extend your booking.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),

            // ── Range card grid ─────────────────────────────────────────
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(slots.length - 1, (i) {
                final startTime = slots[i];
                final endTime   = slots[i + 1];
                final label     = '$startTime – $endTime';

                final occupied   = controller.isSlotOccupied(day, startTime);
                final isSelected = selected.contains(startTime);

                // A free slot is "non-adjacent" (and thus dimmed) only when
                // there is already a selection and this slot cannot extend it.
                final hasSelection = selected.isNotEmpty;
                final firstIdx = hasSelection
                    ? slots.indexOf(selected.first)
                    : -1;
                final lastIdx = hasSelection
                    ? slots.indexOf(selected.last)
                    : -1;
                final isAdjacentBefore = hasSelection && i == firstIdx - 1;
                final isAdjacentAfter  = hasSelection && i == lastIdx + 1;
                final isDimmed = !occupied &&
                    !isSelected &&
                    hasSelection &&
                    !isAdjacentBefore &&
                    !isAdjacentAfter;

                // ── Visual states ──────────────────────────────────────
                Color bgColor;
                Color textColor;
                Color borderColor;
                List<BoxShadow> shadows = [];

                if (occupied) {
                  bgColor     = Colors.red.shade50;
                  textColor   = Colors.red.shade300;
                  borderColor = Colors.red.shade200;
                } else if (isSelected) {
                  bgColor     = AppTheme.primary;
                  textColor   = Colors.white;
                  borderColor = AppTheme.primary;
                  shadows = [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ];
                } else if (isAdjacentBefore || isAdjacentAfter) {
                  // Highlight "can extend here" slots subtly
                  bgColor     = AppTheme.primary.withValues(alpha: 0.07);
                  textColor   = AppTheme.primaryDark;
                  borderColor = AppTheme.primary.withValues(alpha: 0.35);
                } else {
                  bgColor     = Colors.white;
                  textColor   = Colors.black87;
                  borderColor = Colors.grey.shade300;
                }

                return Opacity(
                  opacity: isDimmed ? 0.40 : 1.0,
                  child: GestureDetector(
                    onTap: occupied
                        ? null
                        : () => controller.onHourlyRangeTapped(startTime),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 1.5),
                        boxShadow: shadows,
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            decoration: occupied
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            // ── Selection summary ────────────────────────────────────────
            if (summaryLabel != null) ...[
              const SizedBox(height: 14),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 16, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      summaryLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
   _HalfDaySlotPicker({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final day = controller.selectedDay.value!;

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Divider(),
            Text(
              'The slots',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryDark,
              ),
            ),
             SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _halfDayCard(
                    context: context,
                    timeRange: '${controller.halfDayOpenTime} – ${controller.halfDayMidTime}',
                    slotKey: controller.halfDayOpenTime,
                    day: day,
                  ),
                ),
                 SizedBox(width: 12),
                Expanded(
                  child: _halfDayCard(
                    context: context,
                    timeRange: '${controller.halfDayMidTime} – ${controller.halfDayCloseTime}',
                    slotKey: controller.halfDayMidTime,
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
    required String timeRange,
    required String slotKey,
    required DateTime day,
  }) {
    // Use the overlap-aware check: any hourly booking within this half-day
    // range should mark the slot as unavailable.
    final occupied = controller.isHalfDaySlotOccupied(day, slotKey);
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
        duration:  Duration(milliseconds: 180),
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
                      offset:  Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        child: Column(
          children: [
            Text(
              timeRange,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: labelColor,
                decoration: occupied ? TextDecoration.lineThrough : null,
              ),
            ),
            if (occupied) ...[
               SizedBox(height: 6),
              Text(
                'Reserved',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
