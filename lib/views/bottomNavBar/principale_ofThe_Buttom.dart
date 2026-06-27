import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/nav_controller.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/settings_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/balance_screen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/reservations_screen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/home_page_screen.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController controller = Get.put(NavController());

    final List<Widget> pages = [
      HomePage(),
      BalanceScreen(),
      ReservationsScreen(),
      SettingsScreen(),
    ];

    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            margin:  EdgeInsets.only(left: 20, right: 20, bottom: 20),
            padding:  EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color:  Color(0xFFE2A84B).withValues(alpha: 0.15), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  spreadRadius: 0,
                  offset:  Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context,
                  index: 0,
                  icon: Icons.home_rounded,
                  label: TKeys.navHome.tr,
                  selectedIndex: controller.selectedIndex.value,
                  onTap: controller.navigation,
                ),
                _buildNavItem(
                  context,
                  index: 1,
                  icon: Icons.account_balance_wallet_rounded,
                  label: TKeys.navBalance.tr,
                  selectedIndex: controller.selectedIndex.value,
                  onTap: controller.navigation,
                ),
                _buildNavItem(
                  context,
                  index: 2,
                  icon: Icons.event_note_rounded,
                  label: TKeys.navBookings.tr,
                  selectedIndex: controller.selectedIndex.value,
                  onTap: controller.navigation,
                ),
                _buildNavItem(
                  context,
                  index: 3,
                  icon: Icons.settings,
                  label: TKeys.navSettings.tr,
                  selectedIndex: controller.selectedIndex.value,
                  onTap: controller.navigation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required int selectedIndex,
    required ValueChanged<int> onTap,
  }) {
    final bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration:  Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primary.withValues(alpha: 0.12) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              // When selected, use the premium Amber-Gold color. Otherwise, grey.
              color: isSelected ?  Color(0xFFE2A84B) : Colors.grey.shade400,
              size: 24,
            ),
            if (isSelected) ...[
               SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}