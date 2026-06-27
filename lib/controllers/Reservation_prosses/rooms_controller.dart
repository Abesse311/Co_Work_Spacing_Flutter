import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/room_model.dart';
import 'package:flutter_projet_tutore/variable.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';

class RoomsController extends GetxController {
  final rooms = <Room>[].obs;
  final isLoading = true.obs;
  final String locationName;

  RoomsController({required this.locationName});

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      final response = await http.get(
        Uri.parse('${ngrok_url}/rooms/by-location/$locationName'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        rooms.value = data.map((item) => Room.fromJson(item)).toList();
      } else {
        AppSnackbar.error('Erreur', 'Impossible de charger les salles');
      }
    } catch (e) {
      AppSnackbar.error('Erreur', 'Problème de connexion');
    } finally {
      isLoading.value = false;
    }
  }
}