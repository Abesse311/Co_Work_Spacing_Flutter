import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';

class Auth_SignIn_Controller extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleObscure() {
    obscureText.value = !obscureText.value;
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Champs vides',
        emailController.text.isEmpty
            ? 'Veuillez remplir le champ Email.'
            : 'Veuillez remplir le champ Mot de passe.',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(bottom: 15)
      );
      return;
    }

    final url = Uri.parse('https://ae3b-129-45-96-86.ngrok-free.app/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', emailController.text);
      if (responseData['id'] != null) {
        await prefs.setInt('user_id', responseData['id']);
      }

      Get.snackbar('Succès', 'Connexion réussie !', snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => MyWidget());

    } else {
      Get.snackbar(
        'Erreur',
        jsonDecode(response.body)['error'],
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}