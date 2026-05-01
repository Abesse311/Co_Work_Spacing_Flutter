import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignIn_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/auth/sginUp.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth_SignIn_Controller controller = Get.put(Auth_SignIn_Controller());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, 
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundBeige,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset('img/sgine.jpg', fit: BoxFit.contain),
                  ),
                ),
                 SizedBox(height: 24),
                 Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                 SizedBox(height: 8),
                 Text(
                  'Please log in to continue.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                 SizedBox(height: 32),
                Container(
                  decoration: AppTheme.inputDecoration,
                  child: TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                 SizedBox(height: 16),
                Obx(
                  () => Container(
                    decoration: AppTheme.inputDecoration,
                    child: TextField(
                      controller: controller.passwordController,
                      obscureText: controller.obscureText.value,
                      decoration: InputDecoration(
                      hintText: '••••••••••••••••',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppTheme.textSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureText.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: controller.toggleObscure,
                      ),
                    ),
                    ),
                  ),
                ),
                 SizedBox(height: 32),
                ElevatedButton(
                  onPressed: controller.loginUser,
                  child:  Text(
                    'Log in',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                 SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'already have account? ',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => RegisterScreen()),
                      child: Text(
                        'Sing up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
