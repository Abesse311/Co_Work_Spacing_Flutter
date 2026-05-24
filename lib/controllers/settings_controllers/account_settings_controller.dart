import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/auth_snackbar.dart';

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
      AuthSnackbar.error('Error', 'User not connected. Please log in again.');
      return;
    }

    final provider = await _storage.read(key: 'auth_provider');
    final hasPasswordFlag = await _storage.read(key: 'has_password');
    
    // Decoupled password display logic: if has_password is true, user has password.
    if (hasPasswordFlag == 'true') {
      isGoogleAuth.value = false;
    } else {
      isGoogleAuth.value = (provider == 'google');
    }

    final result = await AuthService.getUserProfile(token);
    isLoading.value = false;

    if (result['success'] == true) {
      final data = result['data'] as Map<String, dynamic>;
      userId = data['uid']?.toString() ?? data['id']?.toString();

      nameController.text = data['name'] ?? data['username'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? data['number']?.toString() ?? '';

      userName.value = nameController.text;
      userEmail.value = emailController.text;
      userPhone.value = phoneController.text;
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        AuthSnackbar.error('Session Expired', 'Your authentication token is invalid or expired.');
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'Could not locate your account user profile.');
        break;
      default:
        AuthSnackbar.error('Error', result['message'] ?? 'Failed to load profile details.');
    }
  }

  // ── UPDATE EMAIL (Two-Step Flow) ──────────────────────────────────────────
  void showEmailUpdateDialog() {
    final emailCtrl = TextEditingController(text: userEmail.value);
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Email'),
        content: TextField(
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'New Email Address',
            hintText: 'Enter your new email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final newEmail = emailCtrl.text.trim();
              if (newEmail.isEmpty) {
                AuthSnackbar.error('Empty Field', 'Please enter your new email address.');
                return;
              }
              if (!GetUtils.isEmail(newEmail)) {
                AuthSnackbar.error('Invalid Email', 'Please enter a valid email address.');
                return;
              }
              Get.back(); // close email dialog
              await _requestEmailUpdate(newEmail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6845),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Next', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// POST /me/email/request
  Future<void> _requestEmailUpdate(String newEmail) async {
    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      isLoading.value = false;
      AuthSnackbar.error('Session Expired', 'You are not logged in.');
      return;
    }

    final result = await AuthService.requestEmailUpdate(newEmail: newEmail, token: token);
    isLoading.value = false;

    if (result['success'] == true) {
      AuthSnackbar.success('Code Sent', 'A verification code has been sent to your new email.');
      _showEmailConfirmDialog(newEmail);
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        AuthSnackbar.error('Session Expired', 'Your authentication token is invalid or expired.');
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'Could not locate your user account.');
        break;
      case 409:
        AuthSnackbar.error('Email Exists', 'This email address is already in use by another account.');
        break;
      case 500:
        AuthSnackbar.error('Email Error', 'Failed to send the verification email. Please try again later.');
        break;
      default:
        AuthSnackbar.error('Error', result['message'] ?? 'Failed to request email update.');
    }
  }

  void _showEmailConfirmDialog(String newEmail) {
    final codeCtrl = TextEditingController();
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Verify New Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('A verification code was sent to $newEmail.', style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            TextField(
              controller: codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final code = codeCtrl.text.trim();
              if (code.isEmpty) {
                AuthSnackbar.error('Empty Field', 'Please enter the verification code.');
                return;
              }
              Get.back();
              await _confirmEmailUpdate(code, newEmail);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6845),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Verify', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// POST /me/email/confirm
  Future<void> _confirmEmailUpdate(String code, String newEmail) async {
    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      isLoading.value = false;
      AuthSnackbar.error('Session Expired', 'You are not logged in.');
      return;
    }

    final result = await AuthService.confirmEmailUpdate(code: code, token: token);
    isLoading.value = false;

    if (result['success'] == true) {
      userEmail.value = newEmail;
      emailController.text = newEmail;
      AuthSnackbar.success('Success ✓', 'Email updated successfully!');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AuthSnackbar.error('No Request Found', 'No pending request to change email is active.');
        break;
      case 401:
        final msg = (result['message'] ?? '').toString().toLowerCase();
        if (msg.contains('token') || msg.contains('expir') || msg.contains('session') || msg.contains('auth')) {
          AuthSnackbar.error('Session Expired', 'Your authentication token is invalid or expired.');
        } else {
          AuthSnackbar.error('Wrong Code', 'The verification code you entered is invalid. Please try again.');
        }
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'Could not locate your user account.');
        break;
      default:
        AuthSnackbar.error('Verification Failed', result['message'] ?? 'Failed to verify new email.');
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
        title: Text(isGoogleAuth.value ? 'Set Password' : 'Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isGoogleAuth.value) ...[
              Obx(() => TextField(
                    controller: oldPassCtrl,
                    obscureText: obscureOld.value,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
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
                    labelText: isGoogleAuth.value ? 'Password' : 'New Password',
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
                    labelText: 'Confirm Password',
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
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              final oldP = oldPassCtrl.text;
              final newP = newPassCtrl.text;
              final confirmP = confirmPassCtrl.text;
              
              if ((!isGoogleAuth.value && oldP.isEmpty) || newP.isEmpty || confirmP.isEmpty) {
                AuthSnackbar.error('Empty Fields', 'Please fill in all fields.');
                return;
              }
              if (newP.length < 8) {
                AuthSnackbar.error('Weak Password', 'New password must be at least 8 characters.');
                return;
              }
              if (newP != confirmP) {
                AuthSnackbar.error('Mismatch', 'New passwords do not match!');
                return;
              }
              
              Get.back();
              await _updatePassword(isGoogleAuth.value ? "" : oldP, newP);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E6845),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
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
      AuthSnackbar.error('Session Expired', 'You are not logged in.');
      return;
    }

    final result = await AuthService.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      token: token,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      // Mark that this account now has a password — persists across logins.
      await _storage.write(key: 'has_password', value: 'true');
      if (isGoogleAuth.value) {
        isGoogleAuth.value = false;
        await _storage.write(key: 'auth_provider', value: 'local');
      }
      AuthSnackbar.success('Success ✓', 'Password updated successfully!');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        // Token invalid/expired OR incorrect old password
        if (result['message']?.toString().toLowerCase().contains('old') == true ||
            result['message']?.toString().toLowerCase().contains('ancien') == true) {
          AuthSnackbar.error('Wrong Password', 'The current password you entered is incorrect.');
        } else {
          AuthSnackbar.error('Session Expired', 'Your authentication token is invalid or expired.');
        }
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'Could not locate your user account.');
        break;
      default:
        AuthSnackbar.error('Failed', result['message'] ?? 'Failed to update password.');
    }
  }
}