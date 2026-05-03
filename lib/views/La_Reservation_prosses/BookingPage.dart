import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/Reservation_prosses/booking_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class RoomBookingPage extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomBookingPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.put(
      BookingController(room: room),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation - ${room['name']}'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => controller.availability.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.availability.length,
                  itemBuilder: (context, index) {
                    final day = controller.availability[index];
                    final date = day['date'];
                    final slots = day['time_slots'];

                    return ExpansionTile(
                      title: Text("Date: $date"),
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1.5,
                          ),
                          itemCount: slots.length,
                          itemBuilder: (context, i) {
                            final slot = slots[i];
                            final isAvailable = slot['status'] == 'available';

                            return Obx(() {
                              bool isSelected = false;
                              if (date == controller.selectedDate.value) {
                                if (controller.selectedEnd.value == null) {
                                  isSelected = slot['slot'] == controller.selectedStart.value;
                                } else {
                                  int currentHour = int.parse(slot['slot'].split(':')[0]);
                                  int startHour = int.parse(controller.selectedStart.value!.split(':')[0]);
                                  int endHour = int.parse(controller.selectedEnd.value!.split(':')[0]);
                                  isSelected = currentHour >= startHour && currentHour <= endHour;
                                }
                              }

                              return GestureDetector(
                                onTap: isAvailable
                                    ? () => controller.selectSlot(date, slot['slot'])
                                    : null,
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue
                                        : isAvailable
                                            ? AppTheme.success.withOpacity(0.4)
                                            : AppTheme.textGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      slot['slot'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        ),
                        if (date == controller.selectedDate.value)
                          SizedBox(height: 12),
                      ],
                    );
                  },
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton(
            onPressed: controller.selectedDate.value != null &&
                    controller.selectedStart.value != null &&
                    controller.selectedEnd.value != null
                ? controller.confirmReservation
                : null,
            child: Text("Confirmer la réservation"),
          ),
        ),
      ),
    );
  }
}