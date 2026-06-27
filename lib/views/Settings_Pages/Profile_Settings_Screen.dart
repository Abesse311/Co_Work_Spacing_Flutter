import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/settings_controllers/account_settings_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class AccountSettingsScreen extends StatelessWidget {
   AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileSettingsController controller =
        Get.put(ProfileSettingsController());

    // Always refresh data when this screen is built, regardless of whether
    // the controller was freshly created or recycled from a previous route.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile();
    });

    return Scaffold(
      appBar: AppBar(
        title:  Text(TKeys.accountSettingsTitle.tr),
      ),
      body: Obx(
        () => controller.isLoading.value
            ?  Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:  EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ── Profile Header ─────────────────────────────────────────
                     SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                      child: Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value[0].toUpperCase()
                            : '?',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: 40,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                     SizedBox(height: 16),
                    Text(
                      controller.userName.value,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                     SizedBox(height: 4),
                    Text(
                      controller.userEmail.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                     SizedBox(height: 32),

                    // ── Personal Information Card ──────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        TKeys.personalInformation.tr,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                      ),
                    ),
                     SizedBox(height: 12),
                    Container(
                      decoration: _cardDecoration(),
                      child: Column(
                        children: [
                          // Name Row
                          _buildSettingRow(
                            context,
                            icon: Icons.person_outline,
                            title: TKeys.nameField.tr,
                            value: controller.userName.value,
                            onEdit: controller.showUsernameUpdateDialog,
                          ),
                           Divider(height: 1, indent: 56),

                          // Phone Row (Can change/verify phone)
                          _buildPhoneRow(context, controller),
                        ],
                      ),
                    ),

                     SizedBox(height: 28),

                    // ── Account Information Card ───────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        TKeys.accountInformation.tr,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                      ),
                    ),
                     SizedBox(height: 12),
                    Container(
                      decoration: _cardDecoration(),
                      child: Column(
                        children: [
                          // Email Row — disabled for Google users (email is managed by Google)
                          _buildSettingRow(
                            context,
                            icon: Icons.email_outlined,
                            title: TKeys.emailField.tr,
                            value: controller.userEmail.value,
                            onEdit: controller.isGoogleAuth.value
                                ? null
                                : () => Get.toNamed('/settings/email-change'),
                          ),
                           Divider(height: 1, indent: 56),

                          // Password Row — disabled for Google users (auth managed by Google)
                          _buildSettingRow(
                            context,
                            icon: Icons.lock_outline,
                            title: TKeys.passwordField.tr,
                            value: '••••••••',
                            onEdit: controller.isGoogleAuth.value
                                ? null
                                : controller.showPasswordUpdateDialog,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppTheme.border,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 10,
          offset:  Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSettingRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    required VoidCallback? onEdit,
  }) {
    return ListTile(
      contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: Colors.black54,
            ),
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              color: valueColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: onEdit != null
          ? IconButton(
              icon:  Icon(Icons.edit_outlined, color: Colors.black54, size: 22),
              onPressed: onEdit,
              splashRadius: 24,
            )
          :  SizedBox.shrink(),
    );
  }

  Widget _buildPhoneRow(BuildContext context, ProfileSettingsController controller) {
    final hasPhone = controller.userPhone.value.isNotEmpty;

    return ListTile(
      contentPadding:  EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child:  Icon(Icons.phone_outlined, color: AppTheme.primary, size: 22),
      ),
      title: Text(
        TKeys.phoneField.tr,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              color: Colors.black54,
            ),
      ),
      subtitle: Text(
        hasPhone ? controller.userPhone.value : TKeys.notVerifiedField.tr,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              color: hasPhone ? Colors.black87 : Colors.orange[700],
              fontWeight: FontWeight.w500,
            ),
      ),
      trailing: ElevatedButton.icon(
        // If they have a phone, they can 'Change' it. If not, they can 'Verify'.
        onPressed: () => Get.toNamed('/settings/phone-verify'),
        icon: Icon(hasPhone ? Icons.edit_outlined : Icons.add, size: 16),
        label: Text(
          hasPhone ? TKeys.changeBtn.tr : TKeys.verifyBtn.tr,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: hasPhone ? Colors.grey[200] : AppTheme.primary,
          foregroundColor: hasPhone ? Colors.black87 : Colors.white,
          padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize:  Size(0, 32),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}