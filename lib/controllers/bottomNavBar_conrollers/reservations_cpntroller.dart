import 'dart:convert';
import 'package:flutter_projet_tutore/variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/models/reservation_model.dart';

class ReservationsController extends GetxController {
  final reservations = <Reservation>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null || userId.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse('${ngrok_url}/reservations/user/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        reservations.value = data
            .map((item) => Reservation.fromJson(item))
            .toList();
      } else {
        Get.snackbar('Erreur', 'Impossible de charger les réservations');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Problème de connexion');
    } finally {
      isLoading.value = false;
    }
  }
}