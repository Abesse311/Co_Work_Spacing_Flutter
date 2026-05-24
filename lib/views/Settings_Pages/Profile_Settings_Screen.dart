import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/settings_controllers/account_settings_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

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
        title: const Text('Account Settings'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ── Profile Header ─────────────────────────────────────────
                    const SizedBox(height: 10),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                      child: Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.userName.value,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.userEmail.value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Personal Information Card ──────────────────────────────
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: _cardDecoration(),
                      child: Column(
                        children: [
                          // Name Row (Read Only)
                          _buildSettingRow(
                            icon: Icons.person_outline,
                            title: 'Name',
                            value: controller.userName.value,
                            onEdit: null, // No endpoint to update name currently
                          ),
                          const Divider(height: 1, indent: 56),

                          // Phone Row (Can change/verify phone)
                          _buildPhoneRow(controller),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Account Information Card ───────────────────────────────
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: _cardDecoration(),
                      child: Column(
                        children: [
                          // Email Row
                          _buildSettingRow(
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: controller.userEmail.value,
                            onEdit: controller.showEmailUpdateDialog,
                          ),
                          const Divider(height: 1, indent: 56),

                          // Password Row
                          _buildSettingRow(
                            icon: Icons.lock_outline,
                            title: 'Password',
                            value: controller.isGoogleAuth.value ? 'Set a password' : '••••••••',
                            valueColor: controller.isGoogleAuth.value ? Colors.orange[700] : Colors.black87,
                            onEdit: controller.showPasswordUpdateDialog,
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
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
    required VoidCallback? onEdit,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 15,
          color: valueColor ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: onEdit != null
          ? IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.black54, size: 22),
              onPressed: onEdit,
              splashRadius: 24,
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildPhoneRow(ProfileSettingsController controller) {
    final hasPhone = controller.userPhone.value.isNotEmpty;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.phone_outlined, color: AppTheme.primary, size: 22),
      ),
      title: const Text(
        'Phone',
        style: TextStyle(fontSize: 13, color: Colors.black54),
      ),
      subtitle: Text(
        hasPhone ? controller.userPhone.value : 'Not verified',
        style: TextStyle(
          fontSize: 15,
          color: hasPhone ? Colors.black87 : Colors.orange[700],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: ElevatedButton.icon(
        // If they have a phone, they can 'Change' it. If not, they can 'Verify'.
        onPressed: () => Get.toNamed('/settings/phone-verify'),
        icon: Icon(hasPhone ? Icons.edit_outlined : Icons.add, size: 16),
        label: Text(hasPhone ? 'Change' : 'Verify', style: const TextStyle(fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: hasPhone ? Colors.grey[200] : AppTheme.primary,
          foregroundColor: hasPhone ? Colors.black87 : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 32),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}