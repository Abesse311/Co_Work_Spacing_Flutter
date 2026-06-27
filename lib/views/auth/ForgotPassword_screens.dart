import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/ForgotPassword_controller.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen 1 — Enter Email
// ─────────────────────────────────────────────────────────────────────────────
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image
              Container(
                height: 200,
                decoration: BoxDecoration(color: AppTheme.backgroundBeige),
                child: Center(
                  child: SvgPicture.asset('img/neu.svg', fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 24),
                    Text(
                      'Forgot Password',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.black, fontFamily: 'roboto'),
                    ),
                     SizedBox(height: 8),
                    Text(
                      'Enter your email address and we will send you a reset code.',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                     SizedBox(height: 28),

                    // Email field
                    Container(
                      decoration: AppTheme.inputDecoration,
                      child: TextField(
                        controller: c.emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),

                     SizedBox(height: 24),

                    // Send Code button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                c.isLoading.value ? null : c.sendCode,
                            child: c.isLoading.value
                                ?  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                :  Text(TKeys.sendCodeBtn.tr),
                          ),
                        )),

                     SizedBox(height: 16),

                    // Back to login
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Back to Sign In',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 2 — Enter Verification Code
// ─────────────────────────────────────────────────────────────────────────────
class VerifyResetCodeScreen extends StatelessWidget {
   VerifyResetCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ForgotPasswordController>();
    final String email = Get.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image
              Container(
                height: 200,
                decoration: BoxDecoration(color: AppTheme.backgroundBeige),
                child: Center(
                  child: SvgPicture.asset('img/neu.svg', fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 24),
                    Text(
                      'Enter Code',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.black, fontFamily: 'roboto'),
                    ),
                     SizedBox(height: 8),
                    Text(
                      'A verification code was sent to\n$email',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                     SizedBox(height: 28),

                    // Code field
                    Container(
                      decoration: AppTheme.inputDecoration,
                      child: TextField(
                        controller: c.codeCtrl,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        decoration:  InputDecoration(
                          hintText: '------',
                          prefixIcon: Icon(
                            Icons.lock_clock_outlined,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),

                     SizedBox(height: 24),

                    // Verify button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                c.isLoading.value ? null : c.verifyCode,
                            child: c.isLoading.value
                                ?  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                :  Text(TKeys.verifyCodeBtn.tr),
                          ),
                        )),

                     SizedBox(height: 16),

                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen 3 — Set New Password
// ─────────────────────────────────────────────────────────────────────────────
class ResetPasswordScreen extends StatelessWidget {
   ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image
              Container(
                height: 200,
                decoration: BoxDecoration(color: AppTheme.backgroundBeige),
                child: Center(
                  child: SvgPicture.asset('img/neu.svg', fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     SizedBox(height: 24),
                    Text(
                      'New Password',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.black, fontFamily: 'roboto'),
                    ),
                     SizedBox(height: 8),
                    Text(
                      'Create a new password for your account.',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                     SizedBox(height: 28),

                    // New password field
                    Obx(() => Container(
                          decoration: AppTheme.inputDecoration,
                          child: TextField(
                            controller: c.passwordCtrl,
                            obscureText: c.obscurePassword.value,
                            decoration: InputDecoration(
                              hintText: 'New password',
                              prefixIcon:  Icon(
                                Icons.lock_outline,
                                color: AppTheme.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  c.obscurePassword.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.textSecondary,
                                ),
                                onPressed: () => c.obscurePassword.toggle(),
                              ),
                            ),
                          ),
                        )),

                     SizedBox(height: 16),

                    // Confirm password field
                    Obx(() => Container(
                          decoration: AppTheme.inputDecoration,
                          child: TextField(
                            controller: c.confirmCtrl,
                            obscureText: c.obscureConfirm.value,
                            decoration: InputDecoration(
                              hintText: 'Confirm password',
                              prefixIcon:  Icon(
                                Icons.lock_outline,
                                color: AppTheme.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  c.obscureConfirm.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppTheme.textSecondary,
                                ),
                                onPressed: () => c.obscureConfirm.toggle(),
                              ),
                            ),
                          ),
                        )),

                     SizedBox(height: 24),

                    // Reset button
                    Obx(() => SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: c.isLoading.value
                                ? null
                                : c.resetPassword,
                            child: c.isLoading.value
                                ?  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                :  Text(TKeys.resetPasswordBtn.tr),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
