import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/services/deep_link_service.dart';

class Auth_SignIn_Controller extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;
  final isLoginLoading = false.obs;
  final isGoogleLoading = false.obs;

  static const _storage  = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // ── UI helpers ─────────────────────────────────────────────────────────────
  void toggleObscure() => obscureText.value = !obscureText.value;

  void forgotPassword() => Get.toNamed('/forgot-password');

  // ── EMAIL / PASSWORD SIGN IN ───────────────────────────────────────────────
  /// POST /auth/local/login
  Future<void> authEmail_Password() async {
    final email    = emailController.text.trim();
    final password = passwordController.text;

    // ── Frontend validation (empty / format only) ──────────────────────────
    if (email.isEmpty || password.isEmpty) {
      AppSnackbar.error(TKeys.emptyFields.tr, TKeys.pleaseEnterEmailPassword.tr);
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AppSnackbar.error(TKeys.invalidEmail.tr, TKeys.pleaseEnterValidEmail.tr);
      return;
    }

    isLoginLoading.value = true;
    final result = await AuthService.login(email: email, password: password);
    isLoginLoading.value = false;

    if (result['success'] == true) {
      final token = result['token'] as String? ?? '';
      await _persistSession(token, provider: 'local');
      AppSnackbar.success(TKeys.welcomeBack.tr, TKeys.youAreNowSignedIn.tr);
      Get.offAllNamed('/home');
      await _checkPhoneAndPrompt(token);
      // Replay any pending deep-link booking that arrived while logged out
      await DeepLinkService.to.triggerPendingIfAny();
      return;
    }

    // ── Backend business errors ──────────────────────────────────────────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        AppSnackbar.error(TKeys.wrongSignInMethod.tr, TKeys.thisAccountUsesGoogle.tr);
        break;
      case 401:
        AppSnackbar.error(TKeys.loginFailed.tr, TKeys.incorrectEmailOrPassword.tr);
        break;
      default:
        AppSnackbar.error(TKeys.loginFailed.tr,
            result['message'] ?? TKeys.anErrorOccurred.tr);
    }
  }

  // ── GOOGLE SIGN-IN ─────────────────────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;

    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isGoogleLoading.value = false;
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:     googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        isGoogleLoading.value = false;
        AppSnackbar.error(TKeys.error.tr, TKeys.failedFirebaseToken.tr);
        return;
      }

      final result =
          await AuthService.googleSignIn(firebaseToken: firebaseIdToken);
      isGoogleLoading.value = false;

      if (result['success'] == true) {
        final token = result['token'] as String? ?? '';
        await _persistSession(token, provider: 'google');
        Get.offAllNamed('/home');
        await _checkPhoneAndPrompt(token);
        // Replay any pending deep-link booking that arrived while logged out
        await DeepLinkService.to.triggerPendingIfAny();
        return;
      }

      // If backend login failed, sign out from Google/Firebase to force 
      // the account picker again on the next attempt.
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      switch (result['statusCode'] as int? ?? 0) {
        case 403:
          AppSnackbar.error(TKeys.wrongSignInMethod.tr, TKeys.thisAccountUsesEmailPassword.tr);
          break;
        default:
          AppSnackbar.error(TKeys.signInFailed.tr,
              result['message'] ?? TKeys.googleSignInFailed.tr);
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoading.value = false;
      await GoogleSignIn().signOut();
      AppSnackbar.error(TKeys.authenticationError.tr,
          e.message ?? TKeys.anErrorOccurred.tr);
    } catch (e) {
      isGoogleLoading.value = false;
      await GoogleSignIn().signOut();
      AppSnackbar.error(TKeys.error.tr, TKeys.unexpectedError.tr);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _persistSession(String token, {required String provider}) async {
    if (token.isNotEmpty) {
      await _storage.write(key: _tokenKey, value: token);
    }
    await _storage.write(key: 'auth_provider', value: provider);

    final userId = parseUserIdFromToken(token);
    if (userId != null) {
      await _storage.write(key: 'user_id', value: userId);
    }

    if (provider == 'local') {
      await _storage.write(key: 'has_password', value: 'true');
      if (userId != null) {
        await _storage.write(key: 'has_password_$userId', value: 'true');
      }
    }
  }

  Future<void> _checkPhoneAndPrompt(String token) async {
    if (token.isEmpty) return;
    final profileResult = await AuthService.getUserProfile(token);
    if (profileResult['success'] == true) {
      final data  = profileResult['data'] as Map<String, dynamic>;
      final phone = data['phone'] ?? data['number']?.toString() ?? '';
      if (phone.trim().isEmpty) {
        Future.delayed(const Duration(milliseconds: 600), _showPhoneRequiredDialog);
      }
    }
  }

  void _showPhoneRequiredDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          title: Row(
            children: [
              const Icon(Icons.phone_android, color: Color(0xFF2E6845), size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  TKeys.phoneNumberRequired.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            TKeys.phoneRequiredMessage.tr,
            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: Get.back,
                  child: Text(
                    TKeys.later.tr,
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.toNamed('/settings/phone-verify');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E6845),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: Text(
                    TKeys.addPhone.tr,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ── Static helpers ─────────────────────────────────────────────────────────
  static Future<String?> getToken()  => _storage.read(key: _tokenKey);
  static Future<void>    clearToken() => _storage.delete(key: _tokenKey);

  static String? parseUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      final payload    = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded    = utf8.decode(base64Url.decode(normalized));
      final claims     = jsonDecode(decoded) as Map<String, dynamic>;
      final sub        = claims['sub'] ?? claims['id'] ?? claims['user_id'];
      return sub?.toString();
    } catch (_) {
      return null;
    }
  }
}
