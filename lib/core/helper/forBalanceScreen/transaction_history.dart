import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/balance_controller.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final BalanceController controller = Get.find<BalanceController>();

    return Obx(() {
      if (controller.transactions.isEmpty) {
        return  SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              TKeys.transactionHistory.tr,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              final tx = controller.transactions[index];

              final isAddition = tx.type.toLowerCase() == 'recharge' ||
                  tx.type.toLowerCase() == 'deposit' ||
                  tx.amount > 0;

              final color = isAddition ? Colors.green[700]! : Colors.red[700]!;
              final icon = isAddition
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded;
              final sign = isAddition ? '+' : '-';

              final dateStr =
                  "${tx.createdAt.day.toString().padLeft(2, '0')}/${tx.createdAt.month.toString().padLeft(2, '0')}/${tx.createdAt.year} "
                  "${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}";

              String displayTitle;
              switch (tx.type.toLowerCase()) {
                case 'booking':
                  displayTitle = TKeys.txRoomBooking.tr;
                  break;
                case 'cancellation':
                case 'cancelled':
                  displayTitle = TKeys.txCancellationRefund.tr;
                  break;
                case 'recharge':
                case 'deposit':
                  displayTitle = TKeys.txBalanceRecharge.tr;
                  break;
                default:
                  displayTitle =
                      tx.type[0].toUpperCase() + tx.type.substring(1);
              }

              final bool hasRoomInfo =
                  tx.roomName != null && tx.roomName!.trim().isNotEmpty;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.02),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          if (hasRoomInfo) ...[
                            SizedBox(height: 4),
                            Text(
                              tx.roomName!,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (tx.locationName != null &&
                                tx.locationName!.trim().isNotEmpty) ...[
                              SizedBox(height: 2),
                              Text(
                                tx.locationName!,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                          SizedBox(height: 6),
                          Text(
                            '$sign${tx.amount.abs().toStringAsFixed(2)} DZD',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: color,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            dateStr,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
