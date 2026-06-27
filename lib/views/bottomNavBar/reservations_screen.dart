// reservations_screen.dart — tabbed by status
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/reservations_screen_controller.dart';
import 'package:flutter_projet_tutore/models/reservation_model.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/core/helper/forReservationsHistory/reservation_card.dart';
import 'package:get/get.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);
//===================>>
  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(ReservationsController(), permanent: false);

    // Fetch reservations when the screen is navigated to/built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchReservations();
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            TKeys.myReservations.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white,fontSize: 20, fontFamily: "Relicta")
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[800],
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs:  [
              Tab(text: TKeys.confirmed.tr),
              Tab(text: TKeys.cancelled.tr),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return  Center(child: CircularProgressIndicator());
          }

          // Any status that is NOT a cancellation variant is treated as active/confirmed.
          // This is intentionally broad because the backend may return 'active', 'booked',
          // 'pending', 'confirmed', or a French equivalent — we must not miss them.
          const cancelledStatuses = {
            'cancelled', 'canceled', 'annulée', 'annule', 'annulé',
          };

          final confirmed = controller.reservations
              .where((r) => !cancelledStatuses.contains(r.status.toLowerCase()))
              .toList();

          final cancelled = controller.reservations
              .where((r) => cancelledStatuses.contains(r.status.toLowerCase()))
              .toList();

          return TabBarView(
            children: [
              _ReservationList(items: confirmed, controller: controller),
              _ReservationList(items: cancelled, controller: controller),
            ],
          );
        }),
      ),
    );
  }
}

// ── Private list widget ───────────────────────────────────────────────────
class _ReservationList extends StatelessWidget {
  final List<Reservation> items;
  final ReservationsController controller;

  _ReservationList({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.fetchReservations,
        child: ListView(
          physics:  AlwaysScrollableScrollPhysics(),
          children: [
             SizedBox(height: 100),
            Center(
              child: Text(
                TKeys.noReservations.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchReservations,
      child: ListView.builder(
        physics:  AlwaysScrollableScrollPhysics(),
        padding:  EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) => ReservationCard(item: items[index]),
      ),
    );
  }
}
