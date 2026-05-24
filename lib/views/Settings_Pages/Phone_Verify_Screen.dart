import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projet_tutore/controllers/settings_controllers/phone_verify_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class PhoneVerifyScreen extends StatelessWidget {
  const PhoneVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PhoneVerifyController controller = Get.put(PhoneVerifyController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.phone_android_rounded,
                    size: 48,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Phone Verification',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A verified phone number is required to make bookings. '
                    'We\'ll send you a verification code via SMS.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Phone number input ────────────────────────────────────────
            Text(
              'Phone Number',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Container(
                decoration: AppTheme.inputDecoration,
                child: TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  enabled: !controller.codeSent.value,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter your phone number',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Send Code button ──────────────────────────────────────────
            Obx(
              () => !controller.codeSent.value
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.sendCode,
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Send Verification Code',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Code input ────────────────────────────────────
                        Text(
                          'Verification Code',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: AppTheme.inputDecoration,
                          child: TextField(
                            controller: controller.codeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Enter the code',
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Verify button ─────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.verifyCode,
                            child: controller.isLoading.value
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Verify Phone',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Resend / Change number ────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.sendCode,
                              child: Text(
                                'Resend Code',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                controller.codeSent.value = false;
                                controller.codeController.clear();
                              },
                              child: Text(
                                'Change Number',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
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
