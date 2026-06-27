import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/reservations_screen_controller.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/models/reservation_model.dart';

class ReservationCard extends StatelessWidget {
  final Reservation item;

  const ReservationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReservationsController>(); 

    const cancelledStatuses = {
      'cancelled', '', 'annulée',
    };
    final isConfirmed = !cancelledStatuses.contains(item.status.toLowerCase());

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Room image ──────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.only(
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
            padding: EdgeInsets.all(16),
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
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: 18,
                                ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${TKeys.locationPrefix.tr}: ${item.location}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${TKeys.reservationTypePrefix.tr}: ${item.type}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${TKeys.reservationDatePrefix.tr}: ${item.date}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                ),
                          ),
                          if (item.startTime.isNotEmpty) ...[
                            SizedBox(height: 4),
                            Text(
                              '${TKeys.timePrefix.tr}: ${item.endTime.isNotEmpty ? '${item.startTime} - ${item.endTime}' : item.startTime}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    // Status badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isConfirmed
                            ? AppTheme.success.withValues(alpha: 0.1)
                            : AppTheme.errorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isConfirmed ? TKeys.confirmed.tr : TKeys.cancelled.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

                SizedBox(height: 12),

                // Price + Cancel button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.price} DZD',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (item.canCancel)
                      TextButton.icon(
                        onPressed: () => controller.cancelReservation(item),
                        icon: Icon(Icons.cancel_outlined, size: 16),
                        label: Text(TKeys.cancel.tr),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade700,
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
