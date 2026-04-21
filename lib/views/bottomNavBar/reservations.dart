// historiques de reservations /////////////////////// 1 
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/reservations_cpntroller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/models/reservation_model.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReservationsController controller = Get.put(ReservationsController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 104, 69),
        elevation: 0,
        title: const Text(
          'My Reservations',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.reservations.isEmpty
                ? const Center(child: Text("No reservations found."))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.reservations.length,
                    itemBuilder: (context, index) {
                      final Reservation item = controller.reservations[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: item.image.startsWith("data:image")
                                  ? Image.memory(
                                      base64Decode(item.image.split(',').last),
                                      width: 120,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "img/default_room.jpg",
                                      width: 120,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${item.price} DZD",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 46, 104, 69),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.status,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: item.status == "Confirmed"
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
