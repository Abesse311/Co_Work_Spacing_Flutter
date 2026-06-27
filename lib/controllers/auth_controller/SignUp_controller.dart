import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

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

    // ── Frontend validation ────────────────────────────────────────────────
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      AppSnackbar.error(TKeys.emptyFields.tr, TKeys.fillAllRequiredFields.tr);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AppSnackbar.error(TKeys.invalidEmail.tr, TKeys.pleaseEnterValidEmail.tr);
      return;
    }
    if (password.length < 8) {
      AppSnackbar.error(TKeys.weakPassword.tr, TKeys.passwordMin8Chars.tr);
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

    // ── Backend business errors ────────────────────────────────────────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AppSnackbar.error(TKeys.emailAlreadyUsed.tr, TKeys.emailAlreadyExists.tr);
        break;
      case 422:
        AppSnackbar.error(TKeys.invalidData.tr, TKeys.checkInputsTryAgain.tr);
        break;
      case 500:
        AppSnackbar.error(TKeys.emailError.tr, TKeys.couldNotSendVerificationEmail.tr);
        break;
      default:
        AppSnackbar.error(TKeys.signUpFailed.tr,
            result['message'] ?? TKeys.anErrorOccurred.tr);
    }
  }

  void toggleObscure() => obscureText.value = !obscureText.value;
}
