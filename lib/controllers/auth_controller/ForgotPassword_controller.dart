import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/auth_snackbar.dart';

class ForgotPasswordController extends GetxController {
  // ── Step 1: Email ──────────────────────────────────────────────────────
  final emailCtrl = TextEditingController();

  // ── Step 2: Code ───────────────────────────────────────────────────────
  final codeCtrl = TextEditingController();

  // ── Step 3: New password ───────────────────────────────────────────────
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final obscurePassword = true.obs;
  final obscureConfirm = true.obs;

  final isLoading = false.obs;

  // Store across steps
  String _email = '';
  String _resetToken = '';

  @override
  void onClose() {
    emailCtrl.dispose();
    codeCtrl.dispose();
    passwordCtrl.dispose();
    confirmCtrl.dispose();
    super.onClose();
  }

  // ── Step 1: Send reset code ────────────────────────────────────────────
  /// POST /auth/local/forgot-password
  Future<void> sendCode() async {
    final email = emailCtrl.text.trim();

    // ── Frontend validation ──────────────────────────────────────────────
    if (email.isEmpty) {
      AuthSnackbar.error('Empty Field', 'Please enter your email address.');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AuthSnackbar.error('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    isLoading.value = true;
    final result = await AuthService.forgotPassword(email: email);
    isLoading.value = false;

    if (result['success'] == true) {
      _email = email;
      AuthSnackbar.success('Code Sent', 'A verification code has been sent to your email.');
      Get.toNamed('/forgot-password/verify', arguments: email);
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 404:
        AuthSnackbar.error('User Not Found', 'No user was found registered with this email.');
        break;
      case 500:
        AuthSnackbar.error('Email Error', 'Failed to send the reset code email. Please try again later.');
        break;
      default:
        AuthSnackbar.error('Reset Failed', result['message'] ?? 'Could not send verification code.');
    }
  }

  // ── Step 2: Verify code ────────────────────────────────────────────────
  /// POST /auth/local/verify-reset-code
  Future<void> verifyCode() async {
    final code = codeCtrl.text.trim();

    // ── Frontend validation ──────────────────────────────────────────────
    if (code.isEmpty) {
      AuthSnackbar.error('Empty Field', 'Please enter the verification code.');
      return;
    }

    isLoading.value = true;
    final result = await AuthService.verifyResetCode(email: _email, code: code);
    isLoading.value = false;

    if (result['success'] == true) {
      _resetToken = result['reset_token']?.toString() ?? '';
      AuthSnackbar.success('Code Verified ✓', 'Please choose a new password.');
      Get.toNamed('/forgot-password/reset');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AuthSnackbar.error('Expired Code', 'No active reset request was found for this email.');
        break;
      case 401:
        AuthSnackbar.error('Invalid Code', 'The verification code you entered is incorrect.');
        break;
      default:
        AuthSnackbar.error('Verification Failed', result['message'] ?? 'Code verification failed.');
    }
  }

  // ── Step 3: Reset password ─────────────────────────────────────────────
  /// POST /auth/local/reset-password
  Future<void> resetPassword() async {
    final password = passwordCtrl.text;
    final confirm = confirmCtrl.text;

    // ── Frontend validation ──────────────────────────────────────────────
    if (password.isEmpty || confirm.isEmpty) {
      AuthSnackbar.error('Empty Fields', 'Please fill in both password fields.');
      return;
    }
    if (password.length < 8) {
      AuthSnackbar.error('Weak Password', 'Password must be at least 8 characters.');
      return;
    }
    if (password != confirm) {
      AuthSnackbar.error('Mismatch', 'Passwords do not match.');
      return;
    }

    isLoading.value = true;
    final result = await AuthService.resetPassword(
      email: _email,
      token: _resetToken,
      newPassword: password,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      AuthSnackbar.success('Success ✓', 'Your password has been reset successfully.');
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AuthSnackbar.error('Access Denied', 'No active reset permission was found for this email.');
        break;
      case 401:
        AuthSnackbar.error('Invalid Reset Token', 'The password reset link or token is invalid or expired.');
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'This user account could not be found.');
        break;
      default:
        AuthSnackbar.error('Reset Failed', result['message'] ?? 'Failed to reset password.');
    }
  }
}
