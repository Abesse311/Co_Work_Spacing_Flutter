import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/views/auth/verifyScreen.dart';
import 'package:get/get.dart';
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
    // ── Basic validation ────────────────────────────────────────────────────
    final name = nameController.text.trim();
    final email = registerEmailController.text.trim();
    final password = registerPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Empty Fields',
        'Please fill in all required fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ── Firebase account creation ───────────────────────────────────────────
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

      // Update display name
      await credential.user?.updateDisplayName(name);

      // Send verification email immediately — do NOT go to Home yet
      await credential.user?.sendEmailVerification();

      // Route to the blocking Verify Email screen
      Get.offAll(() => const VerifyEmailScreen());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          'Weak Password',
          'The password provided is too weak.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          'Error',
          'An account already exists for that email.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Invalid Email',
          'The email address is badly formatted.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'too-many-requests') {
        Get.snackbar(
          'Too Many Requests',
          'Please wait a moment before trying again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          e.message ?? 'An error occurred during registration.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
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
