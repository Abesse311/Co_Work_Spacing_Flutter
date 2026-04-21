import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/balance_controller.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final BalanceController balanceController = Get.put(BalanceController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 46, 104, 69),
        elevation: 0,
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 48,
                  color: Color.fromARGB(255, 46, 104, 69),
                ),
                const SizedBox(width: 16),
                Obx(
                  () => Text(
                    balanceController.currentUser.value?.name ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.grey),
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'change email or number',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: controller.goToAccountSettings,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none, color: Colors.grey),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Enable or disable app notifications',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: controller.showNotificationsDialog,
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.grey),
            title: const Text(
              'Help',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Help center, contact us',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            onTap: controller.showHelpDialog,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Disconnect',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            onTap: controller.showLogoutDialog,
          ),
        ],
      ),
    );
  }
}