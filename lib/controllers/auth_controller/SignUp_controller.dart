import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';

class Auth_SignUp_Controller extends GetxController {

  // Login
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Register
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final obscureText = true.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    phoneController.dispose();
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
      Get.snackbar('Succès', 'Connexion réussie !');
      Get.offAll(() => MyWidget());
    } else {
      Get.snackbar('Erreur', jsonDecode(response.body)['error']);
    }
  }

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        registerPasswordController.text.isEmpty ||
        registerEmailController.text.isEmpty) {
      Get.snackbar('Champs vides', 'Veuillez remplir le champ Vide');
      return;
    }

    final url = Uri.parse('https://ae3b-129-45-96-86.ngrok-free.app/users');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": nameController.text,
        "email": registerEmailController.text,
        "password": registerPasswordController.text,
        "number": int.tryParse(phoneController.text) ?? 0,
      }),
    );

    if (response.statusCode == 201) {
      Get.snackbar('Succès', 'Inscription réussie !');
      Get.to(() => LoginScreen());
    } else {
      Get.snackbar('Erreur', jsonDecode(response.body)['error']);
    }
  }
}