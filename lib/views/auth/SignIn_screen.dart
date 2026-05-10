import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignIn_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/auth/sginUp_screen.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //////////////// the image container (no horizontal padding)
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundBeige,
                ),
                child: Center(
                  child: SvgPicture.asset('img/neu.svg', fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                 SizedBox(height: 24),
                
                 Text(
                  'Login',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.black,fontFamily: "roboto"),
                ),


                 Text(
                  'Please log in to continue.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),


                 SizedBox(height: 18),

                 //  TextFields ________________________________________________________________________________________________________

                 //////////////////////////// Email TextFiled 
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

                 //////////////////////////// password TextFiled
                 
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

                /////////////////////////////// FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.forgotPassword,
                    child: Text(
                      'Forgot password?',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 14,fontWeight: FontWeight.w600,
                        color: AppTheme.primary,)
                    ),
                  ),
                ),

                 //  buttonns ________________________________________________________________________________________________________

                 /////////////////////////////// Login button 

                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.authEmail_Password,
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
                                'Log in',
                                style: Theme.of(context).textTheme.titleMedium
                              ),
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: 16),
                 
                

                /////////////////////////////// GOOGLE BUTTON  

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.backgroundLight,
                        foregroundColor: AppTheme.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppTheme.border),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('icons/google.svg'),
                          SizedBox(width: 8),
                          Text(
                            'Continue with Google',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => RegisterScreen()),
                      child:  Text(
                        'Register',
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
      ),
    );
  }
}
