import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/location_model.dart';
import 'package:flutter_projet_tutore/variable.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';

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
        AppSnackbar.error('Erreur', 'Impossible de charger les locations');
      }
    } catch (e) {
      AppSnackbar.error('Erreur', 'Problème de connexion');
    } finally {
      isLoading.value = false;
    }
  }

  void goToRooms(LocationData location) {
    Get.toNamed(
      '/rooms',
      arguments: {
        'locationId':   location.id,
        'locationName': location.name,
        'openingTime':  location.openingTime,
        'closingTime':  location.closingTime,
        'midTime':      location.midTime,
      },
    );
  }
}