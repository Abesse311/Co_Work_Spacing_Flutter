import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/Reservation_prosses/booking_controller.dart';
import 'package:get/get.dart';

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
        title: Text('Réservation - ${room['name']}'),
        backgroundColor: Color.fromARGB(255, 46, 104, 69),
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
                            childAspectRatio: 2.5,
                          ),
                          itemCount: slots.length,
                          itemBuilder: (context, i) {
                            final slot = slots[i];
                            final isAvailable = slot['status'] == 'available';
                            final isSelected = date == controller.selectedDate.value &&
                                (slot['slot'] == controller.selectedStart.value ||
                                    slot['slot'] == controller.selectedEnd.value);

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
                                          ? Colors.green[200]
                                          : Colors.grey[400],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    slot['slot'],
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            );
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