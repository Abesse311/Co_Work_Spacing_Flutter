// reservations_screen.dart — tabbed by status
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/reservations_screen_controller.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/models/reservation_model.dart';
import 'package:get/get.dart';

class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

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
            'My Reservations',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[800],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'Confirmed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final confirmed = controller.reservations
              .where((r) => r.status.toLowerCase() == 'confirmed')
              .toList();

          final cancelled = controller.reservations
              .where((r) =>
                  r.status.toLowerCase() == 'cancelled' ||
                  r.status.toLowerCase() == 'canceled' ||
                  r.status.toLowerCase() == 'annulée' ||
                  r.status.toLowerCase() == 'annule')
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

  const _ReservationList({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.fetchReservations,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 100),
            Center(
              child: Text(
                'No reservations here.',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.fetchReservations,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) =>
            _ReservationCard(item: items[index], controller: controller),
      ),
    );
  }
}

// ── Private card widget ───────────────────────────────────────────────────
class _ReservationCard extends StatelessWidget {
  final Reservation item;
  final ReservationsController controller;

  const _ReservationCard({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isConfirmed = item.status.toLowerCase() == 'confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Room image ──────────────────────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: item.image.startsWith('data:image')
                ? Image.memory(
                    base64Decode(item.image.split(',').last),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'img/default_room.jpg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          // ── Card body ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row + status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Location: ${item.location}',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reservation Type: ${item.type}',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Reservation Date: ${item.date}',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          if (item.startTime.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Time: ${item.endTime.isNotEmpty ? '${item.startTime} - ${item.endTime}' : item.startTime}',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isConfirmed
                            ? AppTheme.success.withValues(alpha: 0.1)
                            : AppTheme.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isConfirmed
                              ? AppTheme.success
                              : AppTheme.errorLight,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price + Cancel button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.price} DZD',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.canCancel)
                      TextButton.icon(
                        onPressed: () => controller.cancelReservation(item),
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Cancel'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.red.shade300),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
