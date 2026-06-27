import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class EmailVerificationCodeController extends GetxController {
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

  Future<void> confirmEmail() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      AppSnackbar.error(TKeys.missingCode.tr, TKeys.enterCodeSentEmail.tr);
      return;
    }

    isLoading.value = true;
    final result = await AuthService.confirmEmail(
      email: email.value,
      code: code,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      AppSnackbar.success(TKeys.emailVerified.tr, TKeys.accountConfirmedSignIn.tr);
      Get.offAllNamed('/login');
      return;
    }

    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AppSnackbar.error(TKeys.codeExpired.tr, TKeys.noCodeFoundEmail.tr);
        break;
      case 401:
        AppSnackbar.error(TKeys.wrongCode.tr, TKeys.codeIncorrectCheckInbox.tr);
        break;
      default:
        AppSnackbar.error(TKeys.verificationFailed.tr,
            result['message'] ?? TKeys.anErrorOccurred.tr);
    }
  }
}
