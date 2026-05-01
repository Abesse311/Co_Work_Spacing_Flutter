import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignUp_controller.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth_SignUp_Controller controller = Get.put(Auth_SignUp_Controller());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration:  BoxDecoration(color: AppTheme.backgroundLight),
              child: Center(
                child: Image.asset('img/sgine.jpg', fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding:  EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                   SizedBox(height: 4),
                  Text(
                    'Please register to log in.',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                   SizedBox(height: 32),

                  // Name
                  Container(
                    decoration: AppTheme.inputDecoration,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                           Icon(
                            Icons.person_outline,
                            color: Colors.black54,
                          ),
                           SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.nameController,
                              decoration:  InputDecoration(
                                hintText: 'User name',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   SizedBox(height: 16),

                  // Email
                  Container(
                    decoration: AppTheme.inputDecoration,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                           Icon(Icons.email, color: Colors.black54),
                           SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.registerEmailController,
                              decoration:  InputDecoration(
                                hintText: 'Email',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   SizedBox(height: 16),

                  // Password
                  Obx(
                    () => Container(
                      decoration: AppTheme.inputDecoration,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                             Icon(
                              Icons.lock_outline,
                              color: Colors.black54,
                            ),
                             SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller:
                                    controller.registerPasswordController,
                                obscureText: controller.obscureText.value,
                                decoration:  InputDecoration(
                                  hintText: '•••••••••••••••',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                controller.obscureText.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black54,
                              ),
                              onPressed: controller.toggleObscure,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height: 16),

                  // Phone
                  Container(
                    decoration: AppTheme.inputDecoration,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                           Icon(Icons.phone, color: Colors.black54),
                           SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              decoration:  InputDecoration(
                                hintText: 'Phone number',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                   SizedBox(height: 24),

                  // Button
                  ElevatedButton(
                    onPressed: controller.registerUser,
                    child:  Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                        onTap: () => Get.to(() => LoginScreen()),
                        child:  Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
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
