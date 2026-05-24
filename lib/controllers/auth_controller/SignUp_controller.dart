import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/auth_snackbar.dart';

class Auth_SignUp_Controller extends GetxController {
  // ── Form controllers ───────────────────────────────────────────────────────
  final nameController             = TextEditingController();
  final registerEmailController    = TextEditingController();
  final registerPasswordController = TextEditingController();

  final obscureText = true.obs;
  final isLoading   = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.onClose();
  }

  // ── REGISTER ───────────────────────────────────────────────────────────────
  /// POST /auth/local/signup
  Future<void> registerEmail_password() async {
    final username = nameController.text.trim();
    final email    = registerEmailController.text.trim();
    final password = registerPasswordController.text.trim();

    // ── Frontend validation (empty / format / strength only) ──────────────
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      AuthSnackbar.error('Empty Fields', 'Please fill in all required fields.');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AuthSnackbar.error('Invalid Email', 'Please enter a valid email address.');
      return;
    }
    if (password.length < 8) {
      AuthSnackbar.error('Weak Password', 'Password must be at least 8 characters.');
      return;
    }

    // ── API call ───────────────────────────────────────────────────────────
    isLoading.value = true;
    final result = await AuthService.signup(
      username: username,
      email: email,
      password: password,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      nameController.clear();
      registerEmailController.clear();
      registerPasswordController.clear();
      Get.toNamed('/verify-email', arguments: email);
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AuthSnackbar.error('Email Already Used',
            'An account with this email already exists. Please sign in.');
        break;
      case 422:
        AuthSnackbar.error('Invalid Data',
            'Please check your inputs and try again.');
        break;
      case 500:
        AuthSnackbar.error('Email Error',
            'We could not send the verification email. Please try again later.');
        break;
      default:
        AuthSnackbar.error('Sign Up Failed',
            result['message'] ?? 'An error occurred. Please try again.');
    }
  }

  void toggleObscure() => obscureText.value = !obscureText.value;
}
