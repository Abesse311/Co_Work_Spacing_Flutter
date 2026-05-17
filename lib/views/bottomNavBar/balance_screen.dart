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
                  ],
                ),
              ),
      ),
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