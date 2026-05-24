import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsController extends GetxController {

  void goToAccountSettings() {
    Get.toNamed('/settings/account');
  }

  void showNotificationsDialog() {
    final isEnabled = true.obs;
    Get.dialog(
      Obx(
        () => AlertDialog(
          title: const Text('Notifications'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Allow Notifications'),
              Switch(
                value: isEnabled.value,
                onChanged: (value) => isEnabled.value = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Contact Us'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('icons/logo.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('WhatsApp: 0533000001'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Image.asset('icons/telegram.png', width: 24, height: 24),
                const SizedBox(width: 8),
                const Text('Telegram: 0733000001'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Disconnect'),
        content: const Text('Are you sure you want to disconnect?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => logout(),
            child: const Text(
              'Disconnect',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    // Clear the JWT so main.dart won't auto-login on next launch
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_id');

    // Sign out from Google & Firebase (clears Google session → forces account picker next time)
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // If the user wasn't signed in via Google/Firebase, ignore errors
    }

    Get.offAllNamed('/login');
  }
}