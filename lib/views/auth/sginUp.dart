import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignUp_controller.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Auth_SignUp_Controller controller = Get.put(Auth_SignUp_Controller());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
              child: Center(
                child: Image.asset('img/sgine.jpg', fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Please register to log in.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),

                  // Name
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.nameController,
                              decoration: const InputDecoration(
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
                  const SizedBox(height: 16),

                  // Email
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.email, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.registerEmailController,
                              decoration: const InputDecoration(
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
                  const SizedBox(height: 16),

                  // Password
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline, color: Colors.black54),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: controller.registerPasswordController,
                                obscureText: controller.obscureText.value,
                                decoration: const InputDecoration(
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
                  const SizedBox(height: 16),

                  // Phone
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
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
                  const SizedBox(height: 24),

                  // Button
                  ElevatedButton(
                    onPressed: controller.registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A5F4C),
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'already have account? ',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => LoginScreen()),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2E6845),
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