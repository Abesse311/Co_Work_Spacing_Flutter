import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/Reservation_prosses/locations_controller.dart';
import 'package:flutter_projet_tutore/core/helper/for%20Reserv_prosses/location_card.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationsController controller = Get.put(LocationsController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        backgroundColor: AppTheme.primaryDark,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.locations.length,
                        itemBuilder: (context, index) {
                          return LocationCard(
                            location: controller.locations[index],
                            onTap: () => controller.goToRooms(
                              controller.locations[index],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: AppTheme.border,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        "Note: Tous nos emplacements disposent d'une salle de repos et d'une salle à manger.",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppTheme.textGrey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}