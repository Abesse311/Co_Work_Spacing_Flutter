import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

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
  Future<void> sendCode() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterEmailAddress.tr);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AppSnackbar.error(TKeys.invalidEmail.tr, TKeys.pleaseEnterValidEmail.tr);
      return;
    }

    isLoading.value = true;
    final result = await AuthService.forgotPassword(email: email);
    isLoading.value = false;

    if (result['success'] == true) {
      _email = email;
      AppSnackbar.success(TKeys.codeSent.tr, TKeys.verificationCodeSent.tr);
      Get.toNamed('/forgot-password/verify', arguments: email);
      return;
    }

    switch (result['statusCode'] as int? ?? 0) {
      case 403:
        // Backend rejects reset for Google-authenticated accounts
        AppSnackbar.error(TKeys.wrongSignInMethod.tr, TKeys.thisAccountUsesGoogle.tr);
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.noUserRegisteredEmail.tr);
        break;
      case 500:
        AppSnackbar.error(TKeys.emailError.tr, TKeys.failedSendResetEmail.tr);
        break;
      default:
        AppSnackbar.error(TKeys.resetFailed.tr,
            result['message'] ?? TKeys.couldNotSendCode.tr);
    }
  }

  // ── Step 2: Verify code ────────────────────────────────────────────────
  Future<void> verifyCode() async {
    final code = codeCtrl.text.trim();

    if (code.isEmpty) {
      AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterVerificationCode.tr);
      return;
    }

    isLoading.value = true;
    final result = await AuthService.verifyResetCode(email: _email, code: code);
    isLoading.value = false;

    if (result['success'] == true) {
      _resetToken = result['reset_token']?.toString() ?? '';
      AppSnackbar.success(TKeys.codeVerified.tr, TKeys.pleaseChooseNewPassword.tr);
      Get.toNamed('/forgot-password/reset');
      return;
    }

    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AppSnackbar.error(TKeys.expiredCode.tr, TKeys.noActiveResetRequest.tr);
        break;
      case 401:
        AppSnackbar.error(TKeys.invalidCode.tr, TKeys.verificationCodeIncorrect.tr);
        break;
      default:
        AppSnackbar.error(TKeys.verificationFailed.tr,
            result['message'] ?? TKeys.verificationFailed.tr);
    }
  }

  // ── Step 3: Reset password ─────────────────────────────────────────────
  Future<void> resetPassword() async {
    final password = passwordCtrl.text;
    final confirm = confirmCtrl.text;

    if (password.isEmpty || confirm.isEmpty) {
      AppSnackbar.error(TKeys.emptyFields.tr, TKeys.fillBothPasswordFields.tr);
      return;
    }
    if (password != confirm) {
      AppSnackbar.error(TKeys.mismatch.tr, TKeys.passwordsDoNotMatch.tr);
      return;
    }
    if (password.length < 8) {
      AppSnackbar.error(TKeys.weakPassword.tr, TKeys.passwordMin8Chars.tr);
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
      AppSnackbar.success(TKeys.passwordResetSuccess.tr, TKeys.passwordResetSuccessMsg.tr);
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');
      return;
    }

    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AppSnackbar.error(TKeys.accessDenied.tr, TKeys.noActiveResetPermission.tr);
        break;
      case 401:
        AppSnackbar.error(TKeys.invalidResetToken.tr, TKeys.resetTokenInvalid.tr);
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.userAccountNotFound.tr);
        break;
      default:
        AppSnackbar.error(TKeys.resetFailed.tr,
            result['message'] ?? TKeys.failedResetPassword.tr);
    }
  }
}
