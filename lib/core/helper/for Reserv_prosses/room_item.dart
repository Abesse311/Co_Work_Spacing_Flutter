import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/models/room_model.dart';

class RoomItem extends StatelessWidget {
  final Room room;

  const RoomItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    // Build a simple price label from booking types
    String priceLabel = '';
    if (room.bookingTypes.isNotEmpty) {
      final prices = room.bookingTypes.map((t) => (t['price'] ?? 0).toDouble()).toList();
      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      priceLabel = 'From ${minPrice.toStringAsFixed(2)} DZD';
    }

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/booking',
          arguments: {
            'id': room.id,
            'name': room.name,
            'capacity': room.capacity,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            if (room.imageBase64 != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.memory(
                  base64Decode(room.imageBase64!),
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    if (priceLabel.isNotEmpty)
                      Text(
                        priceLabel,
                        style: TextStyle(
                          color: Color.fromARGB(255, 46, 104, 69),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 4),
                    Text(
                      'Capacity: ${room.capacity}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}