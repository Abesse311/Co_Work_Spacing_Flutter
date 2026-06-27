import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/balance_controller.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/settings_controller.dart';
import 'package:flutter_projet_tutore/controllers/language_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.put(SettingsController());
    final BalanceController balanceController = Get.put(BalanceController()); 

    // Refresh user data (logic preserved)
    balanceController.fetchUserData();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TKeys.settings.tr,
          style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          // Premium Settings Container Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade100, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.04),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // 1 — Account Settings
                _buildSettingsTile(
                  context,
                  icon: Icons.person_rounded,
                  iconColor: Colors.blue.shade600,
                  iconBgColor: Colors.blue.shade50,
                  title: TKeys.accountSettings.tr,
                  subtitle: TKeys.accountSubtitle.tr,
                  onTap: controller.goToAccountSettings,
                ),
                _buildDivider(),

                // 2 — Notifications Settings
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_rounded,
                  iconColor: Colors.amber.shade700,
                  iconBgColor: Colors.amber.shade50,
                  title: TKeys.notifications.tr,
                  subtitle: TKeys.notificationsSubtitle.tr,
                  onTap: controller.showNotificationsDialog,
                ),
                _buildDivider(),

                // 3 — Help Center
                _buildSettingsTile(
                  context,
                  icon: Icons.help_outline_rounded,
                  iconColor: AppTheme.primary,
                  iconBgColor: AppTheme.primary.withValues(alpha: 0.08),
                  title: TKeys.help.tr,
                  subtitle: TKeys.helpSubtitle.tr,
                  onTap: controller.showHelpDialog,
                ),
                _buildDivider(),

                // 3.5 — Cancellation and Refund Policy
                _buildSettingsTile(
                  context,
                  icon: Icons.receipt_long_rounded,
                  iconColor: Colors.teal.shade600,
                  iconBgColor: Colors.teal.shade50,
                  title: TKeys.cancellationRefundPolicy.tr,
                  subtitle: TKeys.cancellationRefundSubtitle.tr,
                  onTap: controller.showCancellationRefundDialog,
                ),
                _buildDivider(),

                // 4 — Language Settings
                _buildSettingsTile(
                  context,
                  icon: Icons.language_rounded,
                  iconColor: Colors.indigo.shade600,
                  iconBgColor: Colors.indigo.shade50,
                  title: TKeys.language.tr,
                  subtitle: TKeys.languageSubtitle.tr,
                  onTap: () => _showLanguageSelector(context),
                ),
                _buildDivider(),

                // 5 — Log Out
                _buildSettingsTile(
                  context,
                  icon: Icons.logout_rounded,
                  iconColor: Colors.red.shade600,
                  iconBgColor: Colors.red.shade50,
                  title: TKeys.logOut.tr,
                  subtitle: TKeys.logoutSubtitle.tr,
                  onTap: controller.showLogoutDialog,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red.shade600 : const Color.fromARGB(221, 0, 0, 0),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12.5,
            color: isDestructive ? Colors.red.shade300 : Colors.grey.shade500,
          ),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: isDestructive ? Colors.red.shade200 : Colors.grey.shade400,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade100,
      height: 1,
      thickness: 1.5,
      indent: 20,
      endIndent: 20,
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final LanguageController languageController = Get.find<LanguageController>();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TKeys.selectLanguage.tr,
              style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,color: Colors.black
                )
            ),
            const SizedBox(height: 20),
            Obx(() => ListTile(
              leading: const Icon(Icons.abc, color: AppTheme.primary),
              title: Text(
                TKeys.english.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: languageController.currentLang.value == 'en'
                  ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary)
                  : null,
              onTap: () {
                languageController.changeLanguage('en');
                Get.back();
              },
            )),
            Obx(() => ListTile(
              leading: const Icon(Icons.translate_rounded, color: AppTheme.primary),
              title: Text(
                TKeys.french.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: languageController.currentLang.value == 'fr'
                  ? const Icon(Icons.check_circle_rounded, color: AppTheme.primary)
                  : null,
              onTap: () {
                languageController.changeLanguage('fr');
                Get.back();
              },
            )),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}