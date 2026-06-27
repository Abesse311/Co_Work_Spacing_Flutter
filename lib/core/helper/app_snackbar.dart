import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized snackbar helper for all controllers and widgets.
/// Eliminates duplicated _snack() / Get.snackbar() calls everywhere.
class AppSnackbar {
  static const _errorColor   = Color(0xFFAA2213);
  static const _successColor = Color(0xFF2E6845);
  static const _infoColor    = Color.fromARGB(255, 3, 143, 195); // Informational blue for neutral/copy feedback

  static void success(String title, String message) =>
      _show(title, message, _successColor);

  static void error(String title, String message) =>
      _show(title, message, _errorColor);

  /// Neutral / informational feedback (e.g. clipboard copy confirmation).
  static void info(String title, String message) =>
      _show(title, message, _infoColor);

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
