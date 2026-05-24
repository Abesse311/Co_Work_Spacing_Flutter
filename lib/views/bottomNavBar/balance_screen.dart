import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/balance_controller.dart';
import 'package:get/get.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BalanceController controller = Get.put(BalanceController(),permanent: false,);

    // يستدعي fetchUserData في كل مرة تُفتح الصفحة
    controller.fetchUserData();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 46, 104, 69),
          elevation: 0,
          title: Row(
            children: [
               Icon(Icons.person, size: 36, color: Colors.white),
               SizedBox(width: 12),
              Text(
                controller.currentUser.value?.name ?? 'Loading...',
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: controller.isLoading.value
            ?  Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:  EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding:  EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 25,
                      ),
                      decoration: BoxDecoration(
                        color:  Color.fromARGB(255, 46, 104, 69),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color:  Color.fromARGB(255, 46, 104, 69)
                                .withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset:  Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${controller.currentUser.value?.balance.toStringAsFixed(2) ?? '0.00'} DZD',
                            style:  TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                           SizedBox(height: 8),
                          Text(
                            'Current Balance',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                           Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Color.fromARGB(255, 46, 104, 69),
                          ),
                           SizedBox(width: 8),
                           Text(
                            'To charge the Balance',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding:  EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset:  Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Clé 86',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              Image.asset('icons/algerie_poste.jpg', height: 60),
                            ],
                          ),
                           SizedBox(height: 20),
                          _buildInfoRow('Compte', '00xxxxxxxx'),
                          _buildInfoRow('Nom', 'CHARGE'),
                          _buildInfoRow('Prénom', 'DZ'),
                          _buildInfoRow('Adresse', 'ORAN'),
                          _buildInfoRow('Rip', '007 99999 xxxxxxxxxx xx'),
                        ],
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.all(20),
                      child: Container(
                        width: double.infinity,
                        padding:  EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:  Color.fromARGB(255, 243, 246, 244),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:  Color.fromARGB(255, 46, 104, 69)
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Color.fromARGB(255, 170, 34, 19),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Important Information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 170, 34, 19),
                                  ),
                                ),
                              ],
                            ),
                             SizedBox(height: 12),
                            Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey[800],
                                ),
                                children:  [
                                  TextSpan(
                                    text:
                                        'Send the amount of money you want to charge in the application to this postal account, then send the payment receipt to this email ',
                                  ),
                                  TextSpan(
                                    text: 'example@gmail.com',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTransactionHistory(controller),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTransactionHistory(BalanceController controller) {
    if (controller.transactions.isEmpty) {
      return const SizedBox.shrink(); // Hide if no history
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Transaction History',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            final isAddition = tx.type.toLowerCase() == 'recharge' ||
                tx.type.toLowerCase() == 'deposit' ||
                tx.amount > 0;

            final color = isAddition ? Colors.green[700] : Colors.red[700];
            final icon = isAddition
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded;
            final sign = isAddition ? '+' : '-';

            // Format date
            final dateStr =
                "${tx.createdAt.day.toString().padLeft(2, '0')}/${tx.createdAt.month.toString().padLeft(2, '0')}/${tx.createdAt.year} "
                "${tx.createdAt.hour.toString().padLeft(2, '0')}:${tx.createdAt.minute.toString().padLeft(2, '0')}";

            // Build a clean human-readable title from type
            String displayTitle;
            switch (tx.type.toLowerCase()) {
              case 'booking':
                displayTitle = 'Room Booking';
                break;
              case 'cancellation':
              case 'cancelled':
                displayTitle = 'Cancellation Refund';
                break;
              case 'recharge':
              case 'deposit':
                displayTitle = 'Balance Recharge';
                break;
              default:
                displayTitle = tx.type[0].toUpperCase() + tx.type.substring(1);
            }

            // Subtitle: room + location when available
            final bool hasRoomInfo =
                tx.roomName != null && tx.roomName!.trim().isNotEmpty;

            return Container(
              margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arrow icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color!.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1 — Transaction type title
                        Text(
                          displayTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),

                        // 2 — Room + location (only for booking/cancellation)
                        if (hasRoomInfo) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.meeting_room_outlined,
                                  size: 13, color: Colors.black45),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  tx.locationName != null &&
                                          tx.locationName!.trim().isNotEmpty
                                      ? '${tx.roomName} · ${tx.locationName}'
                                      : tx.roomName!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 6),
                        // 3 — Amount
                        Text(
                          '$sign${tx.amount.abs().toStringAsFixed(2)} DZD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // 4 — Date & time
                        Text(
                          dateStr,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
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
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style:  TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}