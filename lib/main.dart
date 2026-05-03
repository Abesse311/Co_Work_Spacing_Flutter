import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/auth/sginUp.dart';
import 'package:flutter_projet_tutore/views/auth/verifyScreen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // void initState() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('===========================/////########################################User is signed in!');
  //     }
  //   });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontFamily: 'SF Pro Display',
        ),
      ),
      home:  RegisterScreen(),
    );
  }
}

/// ──────────────────────────────────────────────────────────────────────────
/// AuthGate — Decides the initial route every time the app starts.
///
/// States:
///   • No user logged in          → RegisterScreen  (Sign Up)
///   • Logged in, NOT verified    → VerifyEmailScreen (blocking gate)
///   • Logged in, verified        → MyWidget (Home)
/// ──────────────────────────────────────────────────────────────────────────
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still loading the auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final User? user = snapshot.data;

        // ── Not logged in → Sign Up screen ──────────────────────────────
        if (user == null) {
          return const RegisterScreen();
        }

        // ── Logged in but email NOT verified → blocking gate ────────────
        if (!user.emailVerified) {
          return const VerifyEmailScreen();
        }

        // ── Logged in and verified → Home ────────────────────────────────
        return MyWidget();
      },
    );
  }
}

