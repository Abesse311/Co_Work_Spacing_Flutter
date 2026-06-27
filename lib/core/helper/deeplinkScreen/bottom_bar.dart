import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class BottomBar extends StatelessWidget {
  final bool     isLoading;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const BottomBar({
    super.key,
    required this.isLoading,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color:       Colors.black.withValues(alpha: 0.06),
            blurRadius:  16,
            offset:      const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isLoading ? null : onCancel,
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding:   const EdgeInsets.symmetric(vertical: 16),
                side:      BorderSide(color: Colors.grey[300]!),
                foregroundColor: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Confirm
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onConfirm,
              icon: isLoading
                  ? const SizedBox(
                      width:  18, height: 18,
                      child:  CircularProgressIndicator(
                        strokeWidth:  2,
                        color:        Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_circle_rounded, size: 18),
              label: Text(isLoading ? 'Confirming…' : 'Confirm Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding:   const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize:   15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
