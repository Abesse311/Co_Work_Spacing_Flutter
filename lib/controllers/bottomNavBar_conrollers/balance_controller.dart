import 'dart:convert';
import 'package:flutter_projet_tutore/models/User_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BalanceController extends GetxController {
  final currentUser = Rxn<User>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('https://ae3b-129-45-96-86.ngrok-free.app/users/$userId'),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        currentUser.value = User.fromJson(userData);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données');
    } finally {
      isLoading.value = false;
    }
  }
}