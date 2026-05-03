import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';
import 'package:flutter_projet_tutore/views/auth/verifyScreen.dart';

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

  /////////////////// FORGOT PASSWORD function
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Empty Field',
        'Please enter your email address first.',
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

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        'Email Sent',
        'A password reset link has been sent to $email.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Not Found',
          'No account found for this email address.',
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
          'Please wait before requesting another reset email.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'network-request-failed') {
        Get.snackbar(
          'Network Error',
          'Check your internet connection and try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          e.message ?? 'An error occurred. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
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

  Future<void> authEmail_Password() async {
    // ── Basic validation ──────────────────────────────────────────────────────
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Empty Fields',
        'Please enter your email and password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // ── Authenticate with Firebase ────────────────────────────────────────
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // ── Force-reload to get the latest emailVerified flag ─────────────────
      await credential.user?.reload();
      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        // ✅ Verified → Home
        Get.offAll(() => MyWidget());
      } else {
        // ❌ Not verified → blocking Verify Email screen
        Get.offAll(() => const VerifyEmailScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Error',
          'No account found for this email.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'Error',
          'Incorrect password.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-credential') {
        Get.snackbar(
          'Error',
          'Incorrect email or password.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-email') {
        Get.snackbar(
          'Error',
          'The email address is badly formatted.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'user-disabled') {
        Get.snackbar(
          'Error',
          'This account has been disabled.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'too-many-requests') {
        Get.snackbar(
          'Too Many Requests',
          'Too many attempts. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'network-request-failed') {
        Get.snackbar(
          'Network Error',
          'Check your internet connection and try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          e.message ?? 'An error occurred.',
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
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // ── Force-reload to get the latest emailVerified flag ─────────────────
      await userCredential.user?.reload();
      final User? user = FirebaseAuth.instance.currentUser;

      // Google accounts are always verified, but we guard anyway
      if (user != null && user.emailVerified) {
        Get.offAll(() => MyWidget());
      } else {
        Get.offAll(() => const VerifyEmailScreen());
      }
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
