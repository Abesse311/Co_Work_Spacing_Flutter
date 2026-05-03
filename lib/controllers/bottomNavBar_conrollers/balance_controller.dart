import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/models/User_model.dart';
import 'package:flutter_projet_tutore/variables.dart';

class BalanceController extends GetxController {
  final currentUser = Rxn<User>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    try {
      final response = await http.get(
        Uri.parse('$ngrok_url/users/$userId'),
      );
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        currentUser.value = User.fromJson(userData);
      } else {
        Get.snackbar('Erreur', 'Failed to load user data');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données');
    } finally {
      isLoading.value = false;
    }
  }
}