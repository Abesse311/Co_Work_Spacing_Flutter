import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/views/auth/email_verification_screen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale_ofThe_Buttom.dart';

class Auth_SignIn_Controller extends GetxController {
  // ── Controllers & state ───────────────────────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscureText = true.obs;
  final isLoading = false.obs;

  /// Secure storage instance — JWT is persisted here after login.
  static const _storage = FlutterSecureStorage();

  /// Key used to store / retrieve the JWT token.
  static const _tokenKey = 'auth_token';

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

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
      // ✅ Credentials valid & email verified → store token → Home
      final token = result['token'] as String? ?? '';
      if (token.isNotEmpty) {
        await _storage.write(key: _tokenKey, value: token);
      }
      _snack('Welcome back! 🎉', 'You are now signed in.', isError: false);
      Get.offAll(() => const MyWidget());
    } else if (result['emailNotVerified'] == true) {
      // ❌ Email not verified → reuse existing EmailVerificationScreen
      // Pass the email as an argument so the screen can display / use it.
      _snack(
        'Email Not Verified',
        'Please verify your email before signing in.',
      );
      Get.to(
        () => const EmailVerificationScreen(),
        arguments: email,
      );
    } else {
      // ❌ Wrong credentials or server error
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

  // ── Private ────────────────────────────────────────────────────────────────
  void _snack(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: isError
          ? const Color(0xFFAA2213).withOpacity(0.9)
          : const Color(0xFF2E6845).withOpacity(0.9),
      colorText: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
