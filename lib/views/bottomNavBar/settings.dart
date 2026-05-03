import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/balance_controller.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/settings_controller.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final BalanceController balanceController = Get.put(BalanceController()); 

    balanceController.fetchUserData();

    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () async{
          await GoogleSignIn().signOut(); // clears Google session → forces account picker next time
          await FirebaseAuth.instance.signOut();
          Get.offAll(() => LoginScreen());
          }, icon: Icon(Icons.exit_to_app))],
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.titleLarge,
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
                  color: AppTheme.primary,
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
            leading: const Icon(Icons.person, color: AppTheme.textGrey),
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'change email or number',
              style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
            ),
            onTap: controller.goToAccountSettings,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none, color: AppTheme.textGrey),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Enable or disable app notifications',
              style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
            ),
            onTap: controller.showNotificationsDialog,
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppTheme.textGrey),
            title: const Text(
              'Help',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: const Text(
              'Help center, contact us',
              style: TextStyle(fontSize: 13, color: AppTheme.textGrey),
            ),
            onTap: controller.showHelpDialog,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorLight),
            title: const Text(
              'Disconnect',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.errorLight,
              ),
            ),
            onTap: controller.showLogoutDialog,
          ),


        ],
      ),
    );
  }
}