import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/models/room_model.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class RoomItem extends StatelessWidget {
  final Room   room;
  final String locationName;
  final String openingTime;
  final String closingTime;

  const RoomItem({
    super.key,
    required this.room,
    this.locationName = '',
    this.openingTime  = '08:00',
    this.closingTime  = '20:00',
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/booking',
          arguments: {
            'id':           room.id,
            'name':         room.name,
            'capacity':     room.capacity,
            'location':     locationName,
            'opening_time': room.openingTime,
            'closing_time': room.closingTime,
            'mid_time':     room.midTime,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image block
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: room.imageBase64 != null
                  ? Image.memory(
                      base64Decode(room.imageBase64!),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF2E6845).withValues(alpha: 0.1),
                            const Color(0xFF2E6845).withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.meeting_room_outlined,
                        size: 48,
                        color: Color(0xFF2E6845),
                      ),
                    ),
            ),
            // Details block
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room Name
                  Text(
                    room.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (room.bookingTypes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      TKeys.reservationTypes.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: room.bookingTypes.map((type) {
                        final typeName = TKeys.translateBookingType(type['name'] ?? '');
                        final price = (type['price'] ?? 0).toDouble();
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E6845).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF2E6845).withValues(alpha: 0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                typeName,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 1,
                                height: 12,
                                color: const Color(0xFF2E6845).withValues(alpha: 0.3),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${price.toStringAsFixed(0)} DZD',
                                style: const TextStyle(
                                  color: Color(0xFF2E6845),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Capacity row
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${room.capacity} seats',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}