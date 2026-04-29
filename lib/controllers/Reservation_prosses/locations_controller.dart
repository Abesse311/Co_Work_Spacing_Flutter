import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/location_model.dart';
import 'package:flutter_projet_tutore/views/La_Reservation_prosses/rooms.dart';
import 'package:flutter_projet_tutore/variables.dart';

class LocationsController extends GetxController {
  final locations = <LocationData>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      final response = await http.get(
        Uri.parse('${ngrok_url}/locations'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        locations.value = data
            .map((item) => LocationData.fromJson(item))
            .toList();
      } else {
        Get.snackbar('Erreur', 'Impossible de charger les locations');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Problème de connexion');
    } finally {
      isLoading.value = false;
    }
  }

  void goToRooms(LocationData location) {
    Get.to(
      () => RoomsScreen(
        locationId: location.id,
        locationName: location.name,
      ),
    );
  }
}