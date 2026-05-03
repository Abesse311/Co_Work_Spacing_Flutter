// historiques de reservations /////////////////////// 1 
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/reservations_cpntroller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/models/reservation_model.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReservationsController controller = Get.put(ReservationsController(),permanent: false); 

    controller.fetchReservations();


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Reservations',
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: AppTheme.cardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: item.image.startsWith("data:image")
                                  ? Image.memory(
                                      base64Decode(item.image.split(',').last),
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "img/default_room.jpg",
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.subtitle,
                                              style: TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: item.status == "Confirmed"
                                              ? AppTheme.success.withOpacity(0.1)
                                              : AppTheme.errorLight.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          item.status,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: item.status == "Confirmed"
                                                ? AppTheme.success
                                                : AppTheme.errorLight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "${item.price} DZD",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.primary,
                                      fontWeight: FontWeight.bold,
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
