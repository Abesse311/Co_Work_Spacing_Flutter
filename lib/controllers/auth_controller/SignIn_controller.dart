import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';

class Auth_SignIn_Controller extends GetxController {
  /////////////////// controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;

  @override
  /////////////////// function: clear the inputs
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /////////////////// UI-function: password textfield
  void toggleObscure() {
    obscureText.value = !obscureText.value;
  }

  /////////////////// LOG INUser function
  // Future<void> loginUser() async {
  //   if (emailController.text.isEmpty || passwordController.text.isEmpty) {
  //     Get.snackbar(
  //       'Champs vides',
  //       emailController.text.isEmpty
  //           ? 'Veuillez remplir le champ Email.'
  //           : 'Veuillez remplir le champ Mot de passe.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       margin: EdgeInsets.only(bottom: 15),
  //     );
  //     return;
  //   }

  //   final url = Uri.parse('${ngrok_url}/login');
  //   final response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({
  //       "email": emailController.text,
  //       "password": passwordController.text,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = jsonDecode(response.body);
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('user_email', emailController.text);
  //     if (responseData['id'] != null) {
  //       await prefs.setInt('user_id', responseData['id']);
  //     }

  //     Get.snackbar(
  //       'Succès',
  //       'Connexion réussie !',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //     Get.offAll(() => MyWidget());
  //   } else {
  //     Get.snackbar(
  //       'Erreur',
  //       jsonDecode(response.body)['error'],
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  void authEmail_Password() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAll(MyWidget());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Erreur',
          'Aucun utilisateur trouvé pour cet email.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Erreur',
          'Mot de passe incorrect.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-credential') {
        Get.snackbar(
          'Erreur',
          'Email ou mot de passe incorrect.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Erreur',
          'L\'adresse email est mal formatée.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'user-disabled') {
        Get.snackbar(
          'Erreur',
          'Ce compte a été désactivé.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'too-many-requests') {
        Get.snackbar(
          'Erreur',
          'Trop de tentatives. Veuillez réessayer plus tard.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'network-request-failed') {
        Get.snackbar(
          'Erreur',
          'Erreur réseau. Vérifiez votre connexion.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Erreur',
          e.message ?? 'Une erreur est survenue.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  /////////////////// GOOGLE SIGN-IN function
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // User cancelled the sign-in dialog
      if (googleUser == null) return;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      Get.offAll(MyWidget());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Google Sign-In Error',
        e.message ?? 'An error occurred during Google sign-in.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Google Sign-In Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
