import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/nav_controller.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

/// Controller for the Phone Verification screen.
///
/// Two-step flow:
///   1. User enters phone number → POST /me/phone/send-code
///   2. User enters SMS code     → POST /me/phone/verify-code
class PhoneVerifyController extends GetxController {
  // ── Form controllers ──────────────────────────────────────────────────────
  final phoneController = TextEditingController();
  final codeController = TextEditingController();

  // ── Observable state ──────────────────────────────────────────────────────
  final isLoading = false.obs;
  final codeSent = false.obs; // true after SMS was sent successfully

  static const _storage = FlutterSecureStorage();

  @override
  void onClose() {
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }

  // ── Step 1: Send SMS code ─────────────────────────────────────────────────
  /// POST /me/phone/send-code
  Future<void> sendCode() async {
    final phone = phoneController.text.trim();

    // ── Frontend validation ──────────────────────────────────────────────────
    if (phone.isEmpty) {
      AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterPhoneNumber.tr);
      return;
    }
    if (phone.length < 9) {
      AppSnackbar.error(TKeys.error.tr, TKeys.pleaseEnterValidPhoneNumber.tr);
      return;
    }

    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
      return;
    }

    final result = await AuthService.sendPhoneCode(phone: phone, token: token);
    isLoading.value = false;

    if (result['success'] == true) {
      codeSent.value = true;
      AppSnackbar.success(TKeys.codeSent.tr, TKeys.verificationCodeSentToPhone.tr.replaceAll('@phone', phone));
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.couldNotLocateUserProfile.tr);
        break;
      case 409:
        AppSnackbar.error(TKeys.error.tr, TKeys.phoneAlreadyRegistered.tr);
        break;
      default:
        AppSnackbar.error(TKeys.error.tr, result['message'] ?? TKeys.couldNotSendCode.tr);
    }
  }

  // ── Step 2: Verify SMS code ───────────────────────────────────────────────
  /// POST /me/phone/verify-code
  Future<void> verifyCode() async {
    final phone = phoneController.text.trim();
    final code = codeController.text.trim();

    // ── Frontend validation ──────────────────────────────────────────────────
    if (code.isEmpty) {
      AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterVerificationCode.tr);
      return;
    }

    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
      return;
    }

    final result = await AuthService.verifyPhoneCode(
      phone: phone,
      code: code,
      token: token,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      AppSnackbar.success(TKeys.success.tr, TKeys.phoneVerifiedSuccess.tr);
      Get.offAllNamed('/home');
      Future.delayed(const Duration(milliseconds: 200), () {
        if (Get.isRegistered<NavController>()) {
          Get.find<NavController>().navigation(3);
        }
      });
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AppSnackbar.error(TKeys.error.tr, TKeys.noPendingCodeForNumber.tr);
        break;
      case 401:
        final msg = (result['message'] ?? '').toString().toLowerCase();
        if (msg.contains('token') || msg.contains('expir') || msg.contains('session') || msg.contains('auth')) {
          AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        } else {
          AppSnackbar.error(TKeys.wrongCode.tr, TKeys.invalidSmsCode.tr);
        }
        break;
      case 403:
        AppSnackbar.error(TKeys.error.tr, TKeys.verificationCodeBelongsToOther.tr);
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.couldNotLocateUserProfile.tr);
        break;
      default:
        AppSnackbar.error(TKeys.verificationFailed.tr, result['message'] ?? TKeys.verificationCodeIncorrect.tr);
    }
  }
}
