import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';

class Auth_SignIn_Controller extends GetxController {
  // ── State ─────────────────────────────────────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;
  final isLoading = false.obs;

  /// Secure storage instance — JWT is persisted here after login.
  static const _storage = FlutterSecureStorage();

  /// Key used to store / retrieve the JWT token.
  static const _tokenKey = 'auth_token';

  // ── UI helpers ─────────────────────────────────────────────────────────────
  void toggleObscure() => obscureText.value = !obscureText.value;

  // ── FORGOT PASSWORD ────────────────────────────────────────────────────────
  /// Placeholder — implement reset-password endpoint later.
  void forgotPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _snack('Empty Field', 'Please enter your email address first.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _snack('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    // TODO: call POST /auth/local/forgot-password once the endpoint is ready.
    _snack(
      'Coming soon',
      'Password reset is not yet available. Please contact support.',
      isError: false,
    );
  }

  // ── SIGN IN ────────────────────────────────────────────────────────────────
  /// POST /auth/local/login
  /// • Success + verified  → store JWT → Home
  /// • Email not verified  → EmailVerificationScreen (email passed via Get.arguments)
  /// • Other error         → snackbar
  Future<void> authEmail_Password() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // ── Validation ────────────────────────────────────────────────────────
    if (email.isEmpty || password.isEmpty) {
      _snack('Empty Fields', 'Please enter your email and password.');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _snack('Invalid Email', 'Please enter a valid email address.');
      return;
    }

    isLoading.value = true;

    final result = await AuthService.login(email: email, password: password);

    isLoading.value = false;

    // ── Handle response ───────────────────────────────────────────────────
    if (result['success'] == true) {
      //  Credentials valid & email verified → store token + user_id → Home
      final token = result['token'] as String? ?? '';
      if (token.isNotEmpty) {
        await _storage.write(key: _tokenKey, value: token);
      }
      // Persist user_id so balance/settings screens can fetch user data
      var userId = result['user_id']?.toString();
      // Fallback: decode user_id from the JWT payload if not returned directly
      if ((userId == null || userId.isEmpty) && token.isNotEmpty) {
        userId = _parseUserIdFromToken(token);
      }
      if (userId != null && userId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);
      }
      _snack('Welcome back! ', 'You are now signed in.', isError: false);
      Get.offAllNamed('/home');
    } else if (result['emailNotVerified'] == true) {
      // ❌ Email not verified → reuse existing EmailVerificationScreen
      // Pass the email as an argument so the screen can display / use it.
      _snack(
        'Email Not Verified',
        'Please verify your email before signing in.',
      );
      Get.toNamed('/verify-email', arguments: email);
    } else if (result['wrongCredentials'] == true) {
      // ❌ 401 → wrong email or password
      _snack('Login Failed', 'Email or password is wrong.');
    } else {
      // ❌ Other server error
      _snack('Login Failed', result['message'] ?? 'An error occurred. Please try again.');
    }
  }

  // ── GOOGLE SIGN-IN (not implemented yet) ──────────────────────────────────
  /// Google Auth is not yet implemented as per project requirements.
  void signInWithGoogle() {
    _snack(
      'Coming soon',
      'Google Sign-In is not yet available.',
      isError: false,
    );
  }

  // ── Static helpers ─────────────────────────────────────────────────────────
  /// Reads the stored JWT token (useful for authenticated API calls).
  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  /// Clears the JWT token (call on logout).
  static Future<void> clearToken() => _storage.delete(key: _tokenKey);

  /// Decodes the JWT payload and returns the user ID from 'sub' or 'id'.
  /// Returns null if the token is malformed or the claim is missing.
  static String? _parseUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length < 2) return null;
      // Base64Url decode the payload (add padding if needed)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> claims = jsonDecode(decoded);
      // FastAPI typically uses 'sub' for the user identifier
      final sub = claims['sub'] ?? claims['id'] ?? claims['user_id'];
      return sub?.toString();
    } catch (_) {
      return null;
    }
  }

  // ── Private ────────────────────────────────────────────────────────────────
  void _snack(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration:  Duration(seconds: 4),
      backgroundColor: isError
          ?  Color(0xFFAA2213).withOpacity(0.9)
          :  Color(0xFF2E6845).withOpacity(0.9),
      colorText:  Color(0xFFFFFFFF),
      margin:  EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
