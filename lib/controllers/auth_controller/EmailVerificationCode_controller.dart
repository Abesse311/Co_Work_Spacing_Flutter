import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/auth_snackbar.dart';

/// Controller for the Email Verification screen.
///
/// Receives the registered [email] from [Auth_SignUp_Controller] via
/// [Get.arguments] and calls POST /auth/local/confirm-email.
/// On success → navigates to the Sign In screen.
class EmailVerificationCodeController extends GetxController {
  // ── State ──────────────────────────────────────────────────────────────────
  final codeController = TextEditingController();
  final isLoading      = false.obs;
  final email          = ''.obs;

  @override
  void onInit() {
    super.onInit();
    email.value = Get.arguments as String? ?? '';
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  // ── CONFIRM EMAIL ──────────────────────────────────────────────────────────
  /// POST /auth/local/confirm-email
  Future<void> confirmEmail() async {
    final code = codeController.text.trim();

    // ── Frontend validation ────────────────────────────────────────────────
    if (code.isEmpty) {
      AuthSnackbar.error('Missing Code',
          'Please enter the verification code sent to your email.');
      return;
    }

    isLoading.value = true;
    final result = await AuthService.confirmEmail(
      email: email.value,
      code: code,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      AuthSnackbar.success('Email Verified ✓',
          'Your account is confirmed. Please sign in.');
      Get.offAllNamed('/login');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        // No code found for this email, or user data not found
        AuthSnackbar.error('Code Expired',
            'No verification code was found for this email. Please sign up again.');
        break;
      case 401:
        // Invalid code
        AuthSnackbar.error('Wrong Code',
            'The verification code is incorrect. Please check your inbox and try again.');
        break;
      default:
        AuthSnackbar.error('Verification Failed',
            result['message'] ?? 'An error occurred. Please try again.');
    }
  }
}
