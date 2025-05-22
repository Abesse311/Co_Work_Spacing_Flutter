import 'package:flutter/material.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/default_profile.png'),
            ),
            SizedBox(width: 12),
            Text(
              'User Name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    //================================================= BODY =================================================//
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 46, 104, 69),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(
                      255,
                      46,
                      104,
                      69,
                    ).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '\$0.00',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Balance',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Privacy Section
            const Text(
              'Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Simple buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: const Color.fromARGB(255, 46, 104, 69),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text('Privacy', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.security,
                        color: const Color.fromARGB(255, 46, 104, 69),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text('Security', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.email,
                        color: const Color.fromARGB(255, 46, 104, 69),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text('Email', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Contact Section
            const Text(
              'Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Contact buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.phone,
                        color: const Color.fromARGB(255, 46, 104, 69),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text('Phone', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.mail,
                        color: const Color.fromARGB(255, 46, 104, 69),
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      const Text('Mail', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
