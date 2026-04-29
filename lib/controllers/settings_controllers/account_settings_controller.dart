import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/variables.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSettingsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // للعرض في الـ UI
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;

  final isLoading = false.obs;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId == null) {
      isLoading.value = false;
      Get.snackbar('Erreur', 'Utilisateur non connecté');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ngrok_url}/users/$userId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['number']?.toString() ?? '';

        // تحديث الـ obs للعرض
        userName.value = data['name'] ?? '';
        userEmail.value = data['email'] ?? '';
        userPhone.value = data['number']?.toString() ?? '';
      } else {
        Get.snackbar('Erreur', 'Failed to load profile');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Error loading profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileField(String field, String value) async {
    isLoading.value = true;
    if (userId == null) {
      isLoading.value = false;
      Get.snackbar('Erreur', 'Utilisateur non connecté');
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('https://ae3b-129-45-96-86.ngrok-free.app/users/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({field: value}),
      );
      if (response.statusCode == 200) {
        if (field == 'name') {
          nameController.text = value;
          userName.value = value;
        }
        if (field == 'email') {
          emailController.text = value;
          userEmail.value = value;
        }
        if (field == 'number') {
          phoneController.text = value;
          userPhone.value = value;
        }
        Get.snackbar('Succès', '$field mis à jour !');
      } else {
        Get.snackbar('Erreur', 'Erreur lors de la mise à jour de $field');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur réseau');
    } finally {
      isLoading.value = false;
    }
  }

  void showEditDialog(String field, String apiField) {
    final tempController = TextEditingController(
      text: field == 'Name'
          ? userName.value
          : field == 'Email'
              ? userEmail.value
              : userPhone.value,
    );
    Get.dialog(
      AlertDialog(
        title: Text('Edit $field'),
        content: TextField(
          controller: tempController,
          decoration: InputDecoration(labelText: field),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await updateProfileField(apiField, tempController.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}