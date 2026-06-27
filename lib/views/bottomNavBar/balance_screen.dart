import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/balance_controller.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/core/helper/forBalanceScreen/info_row_with_copy.dart';
import 'package:flutter_projet_tutore/core/helper/forBalanceScreen/transaction_history.dart';
import 'package:get/get.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BalanceController controller = Get.put(BalanceController(),permanent: false,);

    // Refresh user data when screen opens
    controller.fetchUserData();

    return Obx(
      () => Scaffold(
        body: controller.isLoading.value
            ?  Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  // physics:  BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      //  _______________________________ Top header for name _______________________________ 
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppTheme.primary.withValues(alpha: 0.08),
                              child: Text(
                                controller.currentUser.value?.name.isNotEmpty == true
                                    ? controller.currentUser.value!.name[0].toUpperCase()
                                    : 'U', // !!!!!!!!!!!! 
                                style:  TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                             SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  Text(
                                    controller.currentUser.value?.name ?? 'Loading...',
                                    style:  TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ───────────────────── Balance Card (Credit Card Style Gradient) ───────────────────── 
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient:  LinearGradient(
                            colors: [
                              AppTheme.primary,
                              Color(0xFF3F8F5E),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFE2A84B).withValues(alpha: 0.50), //  AppTheme.primary.withValues(alpha: 0.25)
                              blurRadius: 16,
                              spreadRadius: 0,
                              offset:  Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  TKeys.currentBalance.tr,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.65),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Colors.white.withValues(alpha: 0.7),
                                  size: 24,
                                ),
                              ],
                            ),
                             SizedBox(height: 18),
                            Text(
                              '${controller.currentUser.value?.balance.toStringAsFixed(2) ?? '0.00'} DZD',
                              style:  TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                             SizedBox(height: 24),
                            
                          ],
                        ),
                      ),

                      // ────────────────────────────── How to Charge Balance Section ──────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Row(
                          children: [
                             Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                            ),
                             SizedBox(width: 8),
                             Text(
                              TKeys.howToRecharge.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,  // §§§§ 
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ──────────────────────── compte CCP(Algérie Poste) ────────────────────────
                      Container(
                        width: double.infinity,
                        margin:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        padding:  EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade100, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.04),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset:  Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:  EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primary.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child:  Icon(
                                        Icons.account_balance_rounded,
                                        color: AppTheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                     SizedBox(width: 10),
                                     Text(
                                      TKeys.algeriePoste.tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  'icons/algerie_poste.jpg',
                                  height: 42,
                                ),
                              ],
                            ),
                             SizedBox(height: 16),
                             Divider(height: 1),
                             SizedBox(height: 8),
                             InfoRowWithCopy(label: 'Compte', value: '00xxxxxxxx'),
                             InfoRowWithCopy(label: 'Nom', value: 'CHARGE'),
                             InfoRowWithCopy(label: 'Prénom', value: 'DZ'),
                             InfoRowWithCopy(label: 'Adresse', value: 'ORAN'),
                             InfoRowWithCopy(label: 'Rip', value: '007 99999 xxxxxxxxxx xx'),
                          ],
                        ),
                      ),

                      // ────────────────────────────── Important information Banner ──────────────────────────────
                      Container(
                        margin:  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        padding:  EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:  Color(0xFFFDF3F2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:  Color(0xFFFADBD8),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Icon(
                              Icons.warning_amber_rounded,
                              color: Color(0xFFD93025),
                              size: 20,
                            ),
                             SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    TKeys.importantInfo.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFC5221F),
                                    ),
                                  ),
                                   SizedBox(height: 6),
                                  Text.rich(
                                    TextSpan(
                                      style:  TextStyle(
                                        fontSize: 12.5,
                                        height: 1.4,
                                        color: Color(0xFFB0605E),
                                      ),
                                      children: [
                                         TextSpan(
                                          text: TKeys.chargeInstructions.tr,
                                        ),
                                        TextSpan(
                                          text: 'example@gmail.com',
                                          style:  TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                            color: Color(0xFFC5221F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                       SizedBox(height: 6),

                      // ──────────────────────────────── Transactions History ────────────────────────────────
                       TransactionHistory(),

                       SizedBox(height: 26),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

}