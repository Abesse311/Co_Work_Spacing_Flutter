import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projet_tutore/controllers/settings_controllers/email_change_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

/// Two-step screen for changing the account email address.
///
///   Step 1 — User enters a new email address and taps "Send Code".
///   Step 2 — User enters the verification code sent to the new email.
class EmailChangeScreen extends StatelessWidget {
  const EmailChangeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EmailChangeController controller = Get.put(EmailChangeController());

    return Scaffold(
      appBar: AppBar(
        title:  Text(TKeys.changeEmailTitle.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ─────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.mark_email_unread_rounded,
                    size: 48,
                    color: AppTheme.primary,
                  ),
                   SizedBox(height: 12),
                  Text(
                    TKeys.changeEmailHeader.tr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                   SizedBox(height: 8),
                  Text(
                    TKeys.changeEmailDesc.tr,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),

             SizedBox(height: 28),

            // ── Step 1: New email input ──────────────────────────────────────
            Text(
              TKeys.newEmailLabel.tr,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
            ),
             SizedBox(height: 8),
            Obx(
              () => Container(
                decoration: AppTheme.inputDecoration,
                child: TextField(
                  controller: controller.newEmailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !controller.codeSent.value,
                  decoration: InputDecoration(
                    hintText: TKeys.enterNewEmailHint.tr,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            ),

             SizedBox(height: 16),

            // ── Send Code button / Step 2 ────────────────────────────────────
            Obx(
              () => !controller.codeSent.value

                  // ── Step 1 button ──────────────────────────────────────────
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.requestEmailChange,
                        child: controller.isLoading.value
                            ?  SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                TKeys.sendVerificationCodeBtn.tr,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                      ),
                    )

                  // ── Step 2: Verification code ──────────────────────────────
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TKeys.verificationCodeLabel.tr,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                        ),
                         SizedBox(height: 8),
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
                              hintText: TKeys.enter6DigitCodeHint.tr,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),

                         SizedBox(height: 20),

                        // ── Confirm button ─────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.confirmEmailChange,
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    TKeys.confirmEmailBtn.tr,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                          ),
                        ),

                         SizedBox(height: 12),

                        // ── Resend / Change email links ────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.requestEmailChange,
                              child: Text(
                                TKeys.resendCodeBtn.tr,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                TKeys.changeEmailTitle.tr,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
