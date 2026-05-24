import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/core/helper/auth_snackbar.dart';

class Auth_SignIn_Controller extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;
  final isLoading   = false.obs;

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
      AuthSnackbar.error('Empty Fields', 'Please enter your email and password.');
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AuthSnackbar.error('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    isLoading.value = true;
    final result = await AuthService.login(email: email, password: password);
    isLoading.value = false;

    if (result['success'] == true) {
      await _persistSession(result['token'] as String? ?? '', provider: 'local');
      AuthSnackbar.success('Welcome back!', 'You are now signed in.');
      Get.offAllNamed('/home');
      await _checkPhoneAndPrompt(result['token'] as String? ?? '');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 400:
        // Account registered via Google — must use Google Sign-In
        AuthSnackbar.error('Wrong Sign-In Method',
            'This account uses Google Sign-In. Please use "Continue with Google".');
        break;
      case 401:
        AuthSnackbar.error('Login Failed', 'Incorrect email or password.');
        break;
      case 403:
        // Email not yet confirmed
        AuthSnackbar.error('Email Not Verified',
            'Please verify your email before signing in.');
        Get.toNamed('/verify-email', arguments: email);
        break;
      default:
        AuthSnackbar.error('Login Failed',
            result['message'] ?? 'An error occurred. Please try again.');
    }
  }

  // ── GOOGLE SIGN-IN ─────────────────────────────────────────────────────────
  /// Full Google Sign-In flow:
  ///   1. Google Sign-In → Firebase Auth → get Firebase ID token
  ///   2. POST /auth/firebase with the ID token
  ///   3. Store JWT, navigate home, check phone
  Future<void> signInWithGoogle() async {
    isLoading.value = true;

    try {
      // Step 1 — Google & Firebase
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return; // user cancelled
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
        isLoading.value = false;
        AuthSnackbar.error('Error', 'Failed to get Firebase token. Please try again.');
        return;
      }

      // Step 2 — Backend
      final result =
          await AuthService.googleSignIn(firebaseToken: firebaseIdToken);
      isLoading.value = false;

      if (result['success'] == true) {
        final token = result['token'] as String? ?? '';
        await _persistSession(token, provider: 'google');

        Get.offAllNamed('/home');
        await _checkPhoneAndPrompt(token);
        return;
      }

      // Backend errors (source: error_codes_per_route.md)
      // 401 → Invalid Firebase token
      AuthSnackbar.error('Sign In Failed',
          result['message'] ?? 'Google sign-in failed. Please try again.');
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      AuthSnackbar.error('Authentication Error',
          e.message ?? 'Firebase authentication failed.');
    } catch (e) {
      isLoading.value = false;
      AuthSnackbar.error('Error', 'An unexpected error occurred.');
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Writes the token + provider to secure storage.
  Future<void> _persistSession(String token, {required String provider}) async {
    if (token.isNotEmpty) {
      await _storage.write(key: _tokenKey, value: token);
    }
    await _storage.write(key: 'auth_provider', value: provider);
    if (provider == 'local') {
      // Local login proves the account has a password — persist this
      // so the Account Settings screen shows "Change" not "Set" password
      // even after a subsequent Google sign-in.
      await _storage.write(key: 'has_password', value: 'true');
    }
    final userId = parseUserIdFromToken(token);
    if (userId != null) {
      await _storage.write(key: 'user_id', value: userId);
    }
  }

  /// Fetches the user profile and shows the phone-required dialog if
  /// the account has no verified phone number.
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

  /// Shows a persistent dialog prompting the user to add a phone number.
  void _showPhoneRequiredDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.phone_android, color: Color(0xFF2E6845), size: 28),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Phone Number Required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'To make bookings, you need to verify your phone number. '
            'Please go to your account settings and add your phone number.',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: Text('Later', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/settings/phone-verify');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E6845),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Add Phone', style: TextStyle(color: Colors.white, fontSize: 15)),
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

  /// Decodes the JWT payload and returns the user ID from 'sub' or 'id'.
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
