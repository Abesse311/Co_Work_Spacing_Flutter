import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/nav_controller.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/settings_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/balance_screen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/reservations_screen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/home_page_screen.dart';

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
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,

              onTap: controller.navigation,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded, size: 32),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_rounded, size: 28),
                  label: 'Balance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event_note, size: 28),
                  label: 'Bookings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_box_rounded, size: 28),
                  label: 'Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}