import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/views/auth/email_verification_screen.dart';

class Auth_SignUp_Controller extends GetxController {
  // ── Form controllers ───────────────────────────────────────────────────────
  final nameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  // ── Observable state ───────────────────────────────────────────────────────
  final obscureText = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  /// Validates all fields, calls POST /auth/local/signup,
  /// then navigates to the Email Verification screen on success.
  Future<void> registerEmail_password() async {
    final username = nameController.text.trim();
    final email = registerEmailController.text.trim();
    final password = registerPasswordController.text.trim();
    final phone = phoneController.text.trim();

    // ── Local validation ───────────────────────────────────────────────────
    if (username.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      _snack('Empty Fields', 'Please fill in all required fields.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _snack('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    if (password.length < 6) {
      _snack('Weak Password', 'Password must be at least 6 characters.');
      return;
    }

    // ── API call ───────────────────────────────────────────────────────────
    isLoading.value = true;

    final result = await AuthService.signup(
      username: username,
      email: email,
      password: password,
      phoneNumber: phone,
    );

    isLoading.value = false;

    if (result['success'] == true) {
      // Pass the registered email so the verification screen can use it
      Get.to(
        () => const EmailVerificationScreen(),
        arguments: email,
      );
    } else {
      _snack('Sign Up Failed', result['message']);
    }
  }

  /// Toggles password visibility.
  void toggleObscure() => obscureText.value = !obscureText.value;

  // ── Helper ─────────────────────────────────────────────────────────────────
  void _snack(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: isError
          ? const Color(0xFFAA2213).withOpacity(0.9)
          : const Color(0xFF2E6845).withOpacity(0.9),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
