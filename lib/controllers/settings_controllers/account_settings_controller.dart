import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projet_tutore/variables.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  String? userId;
  static const _storage = FlutterSecureStorage();

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

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Erreur', 'Utilisateur non connecté');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ngrok_url}/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Store uid for update calls
        userId = data['uid']?.toString() ?? data['id']?.toString();

        nameController.text = data['name'] ?? data['username'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? data['number']?.toString() ?? '';

        userName.value = nameController.text;
        userEmail.value = emailController.text;
        userPhone.value = phoneController.text;
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

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Erreur', 'Utilisateur non connecté');
      return;
    }

    // Map local field names to the API's UpdateUserRequest field names
    // API accepts: username, phone (NOT name / number)
    final apiField = field == 'name' ? 'username' : field == 'number' ? 'phone' : field;

    try {
      final response = await http.put(
        Uri.parse('${ngrok_url}/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({apiField: value}),
      );
      print('🔍 PUT /users/$userId [$apiField=$value] → ${response.statusCode}: ${response.body}');
      if (response.statusCode == 200) {
        if (field == 'name') {
          nameController.text = value;
          userName.value = value;
        }
        if (field == 'number') {
          phoneController.text = value;
          userPhone.value = value;
        }
        Get.snackbar('Succès', 'Updated successfully!');
      } else {
        Get.snackbar('Erreur', 'Failed to update (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur réseau: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showEditDialog(String field, String apiField) {
    final isPhone = field == 'Phone';
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
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          inputFormatters: isPhone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          decoration: InputDecoration(
            labelText: field,
            hintText: isPhone ? '10-digit phone number' : null,
            counterText: isPhone ? '' : null, // hides the counter
          ),
          maxLength: isPhone ? 10 : null,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Validate phone: must be exactly 10 digits
              if (isPhone && tempController.text.length != 10) {
                Get.snackbar(
                  'Invalid Phone',
                  'Phone number must be exactly 10 digits.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor:  Color(0xFFFFC107), // amber/yellow
                  colorText:  Color(0xFF1A1A1A),
                  margin:  EdgeInsets.all(12),
                  borderRadius: 12,
                );
                return;
              }
              Get.back();
              await updateProfileField(apiField, tempController.text);
            },
            child:  Text('Save'),
          ),
        ],
      ),
    );
  }
}