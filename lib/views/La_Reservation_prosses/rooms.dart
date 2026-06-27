import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/Reservation_prosses/rooms_controller.dart';
import 'package:flutter_projet_tutore/core/helper/for%20Reserv_prosses/room_item.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class RoomsScreen extends StatelessWidget {
  final int    locationId;
  final String locationName;
  final String openingTime;
  final String closingTime;

   RoomsScreen({
    super.key,
    required this.locationId,
    required this.locationName,
    this.openingTime = '08:00',
    this.closingTime = '20:00',
  });

  @override
  Widget build(BuildContext context) {
    final RoomsController controller = Get.put(
      RoomsController(locationName: locationName),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('$locationName'),
        centerTitle: false,
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: controller.rooms.length,
                itemBuilder: (context, index) {
                  return RoomItem(
                    room: controller.rooms[index],
                    locationName: locationName,
                    openingTime: openingTime,
                    closingTime: closingTime,
                  );
                },
              ),
      ),
    );
  }
}