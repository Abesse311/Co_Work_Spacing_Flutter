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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 40,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Personal Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Name'),
                      subtitle: Text(controller.userName.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            controller.showEditDialog('Name', 'name'),
                      ),
                    ),
                  ),
                  const Divider(),
                  Obx(
                    () => ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: const Text('Email'),
                      subtitle: Text(controller.userEmail.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            controller.showEditDialog('Email', 'email'),
                      ),
                    ),
                  ),
                  const Divider(),
                  Obx(
                    () => ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: const Text('Phone'),
                      subtitle: Text(controller.userPhone.value),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            controller.showEditDialog('Phone', 'number'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}