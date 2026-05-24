import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/services/auth_service.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/nav_controller.dart';
import 'package:flutter_projet_tutore/core/helper/auth_snackbar.dart';

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
      AuthSnackbar.error('Empty Field', 'Please enter your phone number.');
      return;
    }
    if (phone.length < 9) {
      AuthSnackbar.error('Invalid Phone', 'Please enter a valid phone number.');
      return;
    }

    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      AuthSnackbar.error('Session Expired', 'You are not logged in. Please log in again.');
      return;
    }

    final result = await AuthService.sendPhoneCode(phone: phone, token: token);
    isLoading.value = false;

    if (result['success'] == true) {
      codeSent.value = true;
      AuthSnackbar.success('Code Sent', 'A verification code has been sent to $phone.');
      return;
    }

    // ── Backend business errors (source: error_codes_per_route.md) ──────────
    switch (result['statusCode'] as int? ?? 0) {
      case 401:
        AuthSnackbar.error('Session Expired', 'Your authentication token has expired. Please log in again.');
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'Could not locate your account user profile.');
        break;
      case 409:
        AuthSnackbar.error('Phone Already Used', 'This phone number is already registered to another account.');
        break;
      default:
        AuthSnackbar.error('Failed', result['message'] ?? 'Could not send verification code.');
    }
  }

  // ── Step 2: Verify SMS code ───────────────────────────────────────────────
  /// POST /me/phone/verify-code
  Future<void> verifyCode() async {
    final phone = phoneController.text.trim();
    final code = codeController.text.trim();

    // ── Frontend validation ──────────────────────────────────────────────────
    if (code.isEmpty) {
      AuthSnackbar.error('Empty Field', 'Please enter the verification code.');
      return;
    }

    isLoading.value = true;
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      AuthSnackbar.error('Session Expired', 'You are not logged in. Please log in again.');
      return;
    }

    final result = await AuthService.verifyPhoneCode(
      phone: phone,
      code: code,
      token: token,
    );
    isLoading.value = false;

    if (result['success'] == true) {
      AuthSnackbar.success('Phone Verified ✓', 'Your phone number has been verified successfully.');
      
      // Navigate back to /home and switch the bottom nav to the Settings tab (index 3).
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
        AuthSnackbar.error('No Code Found', 'No pending code is registered for this number. Resend the code.');
        break;
      case 401:
        final msg = (result['message'] ?? '').toString().toLowerCase();
        if (msg.contains('token') || msg.contains('expir') || msg.contains('session') || msg.contains('auth')) {
          AuthSnackbar.error('Session Expired', 'Your authentication token is invalid or expired.');
        } else {
          AuthSnackbar.error('Wrong Code', 'The SMS code you entered is invalid. Please try again.');
        }
        break;
      case 403:
        AuthSnackbar.error('Verification Error', 'This verification code belongs to another user account.');
        break;
      case 404:
        AuthSnackbar.error('User Not Found', 'Could not locate your user profile details.');
        break;
      default:
        AuthSnackbar.error('Verification Failed', result['message'] ?? 'The code is incorrect. Please try again.');
    }
  }
}
