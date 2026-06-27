import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/nav_controller.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

/// Controller for the two-step Change Email screen.
///
///   Step 1: User enters new email → POST /me/email/request
///   Step 2: User enters verification code → POST /me/email/confirm
class EmailChangeController extends GetxController {
  // ── Form controllers ──────────────────────────────────────────────────────
  final newEmailController = TextEditingController();
  final codeController     = TextEditingController();

  // ── Observable state ──────────────────────────────────────────────────────
  final isLoading  = false.obs;
  final codeSent   = false.obs; // true after request email was sent successfully
  final _newEmail  = ''.obs;    // stores the email submitted in step 1

  static const _storage = FlutterSecureStorage();

  @override
  void onClose() {
    newEmailController.dispose();
    codeController.dispose();
    super.onClose();
  }

  // ── Step 1: Request email change ──────────────────────────────────────────
  /// POST /me/email/request
  Future<void> requestEmailChange() async {
    final newEmail = newEmailController.text.trim();

    // ── Frontend validation ────────────────────────────────────────────────
    if (newEmail.isEmpty) {
      AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterNewEmail.tr);
      return;
    }
    if (!GetUtils.isEmail(newEmail)) {
      AppSnackbar.error(TKeys.invalidEmail.tr, TKeys.pleaseEnterValidEmail.tr);
      return;
    }

    isLoading.value = true;
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        return;
      }

      final result = await AuthService.requestEmailUpdate(newEmail: newEmail, token: token);

      if (result['success'] == true) {
        _newEmail.value = newEmail;
        codeSent.value  = true;
        AppSnackbar.success(TKeys.codeSent.tr, TKeys.verificationCodeSentToEmail.tr.replaceAll('@email', newEmail));
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
          AppSnackbar.error(TKeys.emailAlreadyExists.tr, TKeys.emailAlreadyInUse.tr);
          break;
        case 500:
          AppSnackbar.error(TKeys.emailError.tr, TKeys.couldNotSendVerificationEmail.tr);
          break;
        default:
          AppSnackbar.error(TKeys.error.tr, result['message'] ?? TKeys.failedToRequestEmailUpdate.tr);
      }
    } catch (e) {
      AppSnackbar.error(TKeys.error.tr, TKeys.unexpectedErrorWithDetails.tr.replaceAll('@error', e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  // ── Step 2: Confirm verification code ─────────────────────────────────────
  /// POST /me/email/confirm
  Future<void> confirmEmailChange() async {
    final code = codeController.text.trim();

    // ── Frontend validation ────────────────────────────────────────────────
    if (code.isEmpty) {
      AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterVerificationCode.tr);
      return;
    }

    isLoading.value = true;
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null || token.isEmpty) {
        AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        return;
      }

      final result = await AuthService.confirmEmailUpdate(code: code, token: token);

      if (result['success'] == true) {
        AppSnackbar.success(TKeys.success.tr, TKeys.emailUpdatedSuccess.tr);
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
          AppSnackbar.error(TKeys.error.tr, TKeys.noPendingEmailRequest.tr);
          break;
        case 401:
          final msg = (result['message'] ?? '').toString().toLowerCase();
          if (msg.contains('token') || msg.contains('expir') || msg.contains('session') || msg.contains('auth')) {
            AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
          } else {
            AppSnackbar.error(TKeys.wrongCode.tr, TKeys.verificationCodeIncorrect.tr);
          }
          break;
        case 404:
          AppSnackbar.error(TKeys.userNotFound.tr, TKeys.couldNotLocateUserProfile.tr);
          break;
        default:
          AppSnackbar.error(TKeys.verificationFailed.tr, result['message'] ?? TKeys.failedToVerifyNewEmail.tr);
      }
    } catch (e) {
      AppSnackbar.error(TKeys.error.tr, TKeys.unexpectedErrorWithDetails.tr.replaceAll('@error', e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
