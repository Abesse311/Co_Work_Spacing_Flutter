import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class InfoRowWithCopy extends StatelessWidget {
  final String label;
  final String value;

   InfoRowWithCopy({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                AppSnackbar.info(
                  TKeys.copied.tr,
                  TKeys.copiedMsg.tr.replaceAll('@label', label),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.copy_rounded,
                  size: 16,
                  color: AppTheme.primary.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
