import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized snackbar helper for all auth controllers.
/// Eliminates the duplicated _snack() method in every controller.
class AuthSnackbar {
  static const _errorColor   = Color(0xFFAA2213);
  static const _successColor = Color(0xFF2E6845);

  static void success(String title, String message) =>
      _show(title, message, _successColor);

  static void error(String title, String message) =>
      _show(title, message, _errorColor);

  static void _show(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: color.withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
