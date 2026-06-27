import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class DetailCard extends StatelessWidget {
  final String locationName;
  final String roomName;
  final String bookingTypeName;
  final String date;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final Widget divider;

  const DetailCard({
    super.key,
    required this.locationName,
    required this.roomName,
    required this.bookingTypeName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (locationName.isNotEmpty) ...[
            DetailRow(
              iconAsset: 'icons/BookingIcons/location.png',
              label: 'Location',
              value: locationName,
            ),
            divider,
          ],
          if (roomName.isNotEmpty) ...[
            DetailRow(
              iconAsset: 'icons/BookingIcons/room.png',
              label: 'Room',
              value: roomName,
            ),
            divider,
          ],
          DetailRow(
            iconAsset: 'icons/BookingIcons/type.png',
            label: 'Type',
            value: bookingTypeName,
          ),
          divider,
          DetailRow(
            iconAsset: 'icons/BookingIcons/date.png',
            label: 'Date',
            value: date,
          ),
          divider,
          DetailRow(
            iconAsset: 'icons/BookingIcons/timee.png',
            label: 'Time',
            value: '$startTime → $endTime',
          ),
          divider,
          // Total price — highlighted
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color:        AppTheme.primary.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:  AppTheme.primary.withValues(alpha: 0.12),
                    shape:  BoxShape.circle,
                  ),
                  child: Image.asset(
                    'icons/BookingIcons/price.png',
                    width:  18,
                    height: 18,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'Total',
                    style: TextStyle(
                      fontSize:   14,
                      fontWeight: FontWeight.w600,
                      color:      AppTheme.primaryDark,
                    ),
                  ),
                ),
                Text(
                  '${totalPrice.toStringAsFixed(0)} DZD',
                  style: const TextStyle(
                    fontSize:   18,
                    fontWeight: FontWeight.bold,
                    color:      AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String iconAsset;
  final String   label;
  final String   value;

  const DetailRow({super.key, required this.iconAsset, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:  AppTheme.primary.withValues(alpha: 0.08),
              shape:  BoxShape.circle,
            ),
            child: Image.asset(iconAsset, width: 22, height: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize:   13,
                color:      Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign:  TextAlign.end,
              style: const TextStyle(
                fontSize:   14,
                color:      Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
