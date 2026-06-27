import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class AmenityTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const AmenityTile({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(right: 10),
      padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primary),
           SizedBox(width: 6),
          Text(
            label,
            style:  TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
