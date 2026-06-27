import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class SettingsController extends GetxController {

  void goToAccountSettings() {
    Get.toNamed('/settings/account');
  }

  void showNotificationsDialog() {
    final isEnabled = true.obs;
    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(TKeys.notifications.tr,style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: Colors.black)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(TKeys.allowNotifications.tr),
              Switch(
                value: isEnabled.value,
                onChanged: (value) => isEnabled.value = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(TKeys.close.tr),
            ),
          ],
        ),
      ),
    );
  }

  // Theme.of(Get.context!).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: Colors.black),

  void showHelpDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(TKeys.contactUs.tr,style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,color: Colors.black)), 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('icons/whatsapp.png', width: 24, height: 24),
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
            child: Text(TKeys.close.tr),
          ),
        ],
      ),
    );
  }

  void showCancellationRefundDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Expanded(
          child: Text(
            TKeys.cancellationRefundPolicy.tr,
            style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,color: Colors.black
                ), // Theme.of(Get.context!).textTheme.bodyLarge
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [
            Text(
              TKeys.cancellationRefundContent.tr,
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(TKeys.close.tr),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(TKeys.disconnect.tr,style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,color: Colors.black
                )),
        content: Text(TKeys.confirmDisconnect.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(TKeys.cancel.tr),
          ),
          TextButton(
            onPressed: () => logout(),
            child: Text(
              TKeys.disconnect.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'auth_provider');
    await storage.delete(key: 'has_password');

    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } catch (_) {}

    Get.offAllNamed('/login');
  }
}