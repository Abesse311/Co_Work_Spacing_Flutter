import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn_screen.dart';

/// Controller for the Email Verification screen.
///
/// Receives the registered [email] from [SignUp_controller] via
/// [Get.arguments] and calls POST /auth/local/confirm-email.
/// On success → navigates to the Sign In screen (JWT is NOT stored here).
class EmailVerificationCodeController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final codeController = TextEditingController();
  final isLoading = false.obs;

  /// The email passed from the Signup controller via [Get.arguments].
  final email = ''.obs;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Get.arguments is the registered email string
    email.value = Get.arguments as String? ?? '';
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  /// Validates the code field and calls the confirm-email endpoint.
  /// On success → clears the navigation stack and pushes [LoginScreen].
  Future<void> confirmEmail() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      _snack('Missing Code', 'Please enter the verification code sent to your email.');
      return;
    }

    if (email.value.isEmpty) {
      _snack('Error', 'Email address is missing. Please sign up again.');
      return;
    }

    isLoading.value = true;

    final result = await AuthService.confirmEmail(
      email: email.value,
      code: code,
    );

    isLoading.value = false;

    if (result['success'] == true) {
      _snack(
        'Email Verified 🎉',
        'Your account is confirmed. Please sign in.',
        isError: false,
      );
      // Clear the entire back-stack → Sign In page
      Get.offAll(() => const LoginScreen());
    } else {
      _snack('Verification Failed', result['message']);
    }
  }

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
