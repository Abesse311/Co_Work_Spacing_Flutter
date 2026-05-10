import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignUp_controller.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn_screen.dart';
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
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.black,fontFamily: "roboto"),
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
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
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
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.registerEmail_password,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              :  Text(
                                  'Sign up',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                   SizedBox(height: 24),

                  

                   ////////////////////////////////////////////////////////

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'already have an account? ',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => LoginScreen()),
                        child:  Text(
                          'Log in',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,
                          color: AppTheme.primary,)
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
