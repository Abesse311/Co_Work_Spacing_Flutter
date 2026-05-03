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
            //////////////////////////// Image continer 
            Container(
              height: 250,
              decoration:  BoxDecoration(color: AppTheme.backgroundLight),
              child: Center(
                child: Image.asset('img/sgine.jpg', fit: BoxFit.fitWidth,width: double.infinity,),
              ),
            ),
            ////////////////////////////////////////////////////////
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  //  SizedBox(height: 4),
                  Text(
                    'Please register to log in.',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  ////////////////////////////////////////////////////////
                  
                   SizedBox(height: 14),

                  //////////////////////////// UserName TextField
                  Container(
                  decoration: AppTheme.inputDecoration,
                  child: TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: 'User name',
                      prefixIcon: Icon(
                        Icons.person_2_outlined,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),

                   SizedBox(height: 16),

                  //////////////////////////// Email TextField
                  Container(
                  decoration: AppTheme.inputDecoration,
                  child: TextField(
                    controller: controller.registerEmailController,
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

                  //////////////////////////// Password TextFiled
                  Obx(
                    () => Container(
                    decoration: AppTheme.inputDecoration,
                    child: TextField(
                      controller: controller.registerPasswordController,
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
                   SizedBox(height: 16),

                  //////////////////////////// Phone Textfiled
                  Container(
                  decoration: AppTheme.inputDecoration,
                  child: TextField(
                    controller: controller.phoneController,
                    decoration: InputDecoration(
                      hintText: 'phone number',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),

                   SizedBox(height: 24),

                  ///////////////////// Sign Up Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.registerEmail_password,
                        child:  Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                   SizedBox(height: 24),

                  ///////////////////// google button 
                  

                   ////////////////////////////////////////////////////////

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
