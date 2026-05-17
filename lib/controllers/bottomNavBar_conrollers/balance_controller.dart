import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/User_model.dart';
import 'package:flutter_projet_tutore/variables.dart';

class BalanceController extends GetxController {
  final currentUser = Rxn<User>();
  final isLoading = true.obs;

  static const _storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;

    // Read the stored JWT token
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      return;
    }

    try {
      // Use /me endpoint — no user_id needed, just the Bearer token
      final response = await http.get(
        Uri.parse('$ngrok_url/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print('🔍 /me response [${response.statusCode}]: ${response.body}');
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        currentUser.value = User.fromJson(userData);
      } else {
        Get.snackbar('Erreur', 'Failed to load user data (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données');
    } finally {
      isLoading.value = false;
    }
  }
}
