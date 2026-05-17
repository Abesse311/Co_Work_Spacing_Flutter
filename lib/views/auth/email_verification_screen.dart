import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/EmailVerificationCode_controller.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmailVerificationCodeController controller =
        Get.put(EmailVerificationCodeController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      // ── AppBar ─────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── Icon ───────────────────────────────────────────────────────
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 56,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              // ── Title ──────────────────────────────────────────────────────
              Text(
                'Check your inbox',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // ── Subtitle ───────────────────────────────────────────────────
              Obx(() => Text(
                    'We sent a verification code to\n${controller.email.value}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 15,
                          height: 1.6,
                        ),
                    textAlign: TextAlign.center,
                  )),

              const SizedBox(height: 40),

              // ── Code input ─────────────────────────────────────────────────
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Verification Code',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                decoration: AppTheme.inputDecoration,
                child: TextField(
                  controller: controller.codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                  ],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: '• • • • • •',
                    hintStyle: TextStyle(
                      fontSize: 22,
                      letterSpacing: 6,
                      color: AppTheme.textSecondary,
                    ),
                    counterText: '',
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: AppTheme.primary,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // ── Confirm button ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.confirmEmail,
                    child: const Text(
                      'Verify Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── Divider ────────────────────────────────────────────────────
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Didn\'t receive it?',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: 20),

              // ── Back to signup ─────────────────────────────────────────────
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Go back and try again',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
