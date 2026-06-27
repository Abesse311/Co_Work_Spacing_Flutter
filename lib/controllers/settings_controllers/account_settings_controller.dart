import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/models/User_model.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class ProfileSettingsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // For displaying in the UI
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;

  final isLoading = false.obs;
  String? userId;
  static const _storage = FlutterSecureStorage();

  final isGoogleAuth = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // ── FETCH USER PROFILE ─────────────────────────────────────────────────────
  /// GET /me
  Future<void> fetchProfile() async {
    isLoading.value = true;

    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      AppSnackbar.error(TKeys.error.tr, TKeys.userNotConnectedMsg.tr);
      return;
    }

    final result = await AuthService.getUserProfile(token);

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      final user = User.fromJson(data);

      // Read the provider stored at login time as a reliable fallback.
      final storedProvider = await _storage.read(key: 'auth_provider');

      // Set ALL state before isLoading = false so the UI renders once with everything correct.
      userId             = user.uid.isNotEmpty ? user.uid : await _storage.read(key: 'user_id');
      isGoogleAuth.value = user.authProvider == 'google' || storedProvider == 'google';

      nameController.text  = user.name;
      emailController.text = user.email;
      phoneController.text = user.phone ?? '';

      userName.value  = user.name;
      userEmail.value = user.email;
      userPhone.value = user.phone ?? '';

      isLoading.value = false; // ← last, so UI renders with correct state already set
      return;
    }

    isLoading.value = false;


    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.couldNotLocateUserProfile.tr);
        break;
      default:
        AppSnackbar.error(TKeys.error.tr, result['message'] ?? TKeys.failedLoadData.tr);
    }
  }

  // ── UPDATE PASSWORD ────────────────────────────────────────────────────────
  void showPasswordUpdateDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();
    
    final obscureOld = true.obs;
    final obscureNew = true.obs;
    final obscureConfirm = true.obs;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isGoogleAuth.value ? TKeys.setPasswordTitle.tr : TKeys.changePasswordTitle.tr,
          style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isGoogleAuth.value) ...[
              Obx(() => TextField(
                    controller: oldPassCtrl,
                    obscureText: obscureOld.value,
                    decoration: InputDecoration(
                      labelText: TKeys.currentPasswordLabel.tr,
                      suffixIcon: IconButton(
                        icon: Icon(obscureOld.value ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => obscureOld.value = !obscureOld.value,
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            Obx(() => TextField(
                  controller: newPassCtrl,
                  obscureText: obscureNew.value,
                  decoration: InputDecoration(
                    labelText: isGoogleAuth.value ? TKeys.passwordField.tr : TKeys.newPasswordLabel.tr,
                    suffixIcon: IconButton(
                      icon: Icon(obscureNew.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => obscureNew.value = !obscureNew.value,
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: confirmPassCtrl,
                  obscureText: obscureConfirm.value,
                  decoration: InputDecoration(
                    labelText: TKeys.confirmPasswordLabel.tr,
                    suffixIcon: IconButton(
                      icon: Icon(obscureConfirm.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => obscureConfirm.value = !obscureConfirm.value,
                    ),
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(TKeys.cancel.tr, style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final oldP = oldPassCtrl.text;
              final newP = newPassCtrl.text;
              final confirmP = confirmPassCtrl.text;
              
              if ((!isGoogleAuth.value && oldP.isEmpty) || newP.isEmpty || confirmP.isEmpty) {
                AppSnackbar.error(TKeys.emptyFields.tr, TKeys.fillAllRequiredFields.tr);
                return;
              }
              if (newP != confirmP) {
                AppSnackbar.error(
                  TKeys.mismatch.tr,
                  TKeys.passwordsDoNotMatch.tr,
                );
                return;
              }
              if (newP.length < 8) {
                AppSnackbar.error(
                  TKeys.weakPassword.tr,
                  TKeys.passwordMin8Chars.tr,
                );
                return;
              }
              
              Get.back();
              await _updatePassword(isGoogleAuth.value ? "" : oldP, newP);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6845),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(TKeys.saveBtn.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// PUT /me/password
  Future<void> _updatePassword(String oldPassword, String newPassword) async {
    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      isLoading.value = false;
      AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.youAreNotLoggedIn.tr);
      return;
    }

    final result = await AuthService.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      token: token,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      if (isGoogleAuth.value) {
        // Edge case: Google user who just set a password — update local session state.
        isGoogleAuth.value = false;
        await _storage.write(key: 'auth_provider', value: 'local');
      }
      AppSnackbar.success(TKeys.success.tr, TKeys.passwordUpdatedSuccess.tr);
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        // Token invalid/expired OR incorrect old password
        final msg = (result['message'] ?? '').toString().toLowerCase();
        if (msg.contains('token') || msg.contains('expir') || msg.contains('session') || msg.contains('auth')) {
          AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        } else {
          AppSnackbar.error(TKeys.wrongPassword.tr, TKeys.currentPasswordIncorrect.tr);
        }
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.userAccountNotFound.tr);
        break;
      default:
        AppSnackbar.error(TKeys.error.tr, result['message'] ?? TKeys.failedToUpdatePassword.tr);
    }
  }

  // ── UPDATE USERNAME ────────────────────────────────────────────────────────
  void showUsernameUpdateDialog() {
    final nameCtrl = TextEditingController(text: userName.value);
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          TKeys.changeUsernameTitle.tr,
          style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: TKeys.usernameLabel.tr,
                hintText: TKeys.enterNewUsernameHint.tr,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text(TKeys.cancel.tr, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameCtrl.text.trim();
              if (newName.isEmpty) {
                AppSnackbar.error(TKeys.emptyField.tr, TKeys.pleaseEnterUsername.tr);
                return;
              }
              if (newName == userName.value) {
                Get.back();
                return;
              }
              Get.back();
              await _updateUsername(newName);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(TKeys.saveBtn.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUsername(String newUsername) async {
    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      isLoading.value = false;
      AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.youAreNotLoggedIn.tr);
      return;
    }

    final result = await AuthService.updateProfile(
      username: newUsername,
      token: token,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      userName.value = newUsername;
      nameController.text = newUsername;
      AppSnackbar.success(TKeys.success.tr, TKeys.usernameUpdatedSuccess.tr);
      return;
    }

    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        AppSnackbar.error(TKeys.sessionExpired.tr, TKeys.sessionExpiredOrInvalid.tr);
        break;
      case 404:
        AppSnackbar.error(TKeys.userNotFound.tr, TKeys.couldNotLocateUserProfile.tr);
        break;
      default:
        AppSnackbar.error(TKeys.error.tr, result['message'] ?? TKeys.failedToUpdateUsername.tr);
    }
  }
}