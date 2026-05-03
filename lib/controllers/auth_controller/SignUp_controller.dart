import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/variables.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class Auth_SignUp_Controller extends GetxController {
  // Register
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final obscureText = true.obs;

  @override
  /////////////////// Clear the inputs
  void onClose() {
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }



  void registerEmail_password() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: registerEmailController.text.trim(), // Access the text property
            password:
                registerPasswordController.text.trim(), // Access the text property
          );
          Get.off(MyWidget());

      print('User registered successfully: ${credential.user?.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error",'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


  /////////////////// registerUser function
  
  // Future<void> registerUser() async {
  //   if (nameController.text.isEmpty ||
  //       phoneController.text.isEmpty ||
  //       registerPasswordController.text.isEmpty ||
  //       registerEmailController.text.isEmpty) {
  //     Get.snackbar(
  //       'Champs vides',
  //       'Veuillez remplir le champ Vide',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     return;
  //   }

  //   final url = Uri.parse('${ngrok_url}/users');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "name": nameController.text,
  //       "email": registerEmailController.text,
  //       "password": registerPasswordController.text,
  //       "number": int.tryParse(phoneController.text) ?? 0,
  //     }),
  //   );

  //   if (response.statusCode == 201) {
  //     Get.snackbar(
  //       'Succès',
  //       'Inscription réussie !',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     Get.to(() => LoginScreen());
  //   } else {
  //     Get.snackbar(
  //       'Erreur',
  //       jsonDecode(response.body)['error'],
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }



  /////////////////// password input function
  void toggleObscure() {
    obscureText.value = !obscureText.value;
  }
}
