import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/auth/SignIn_screen.dart';
import 'package:flutter_projet_tutore/views/auth/sginUp_screen.dart';
import 'package:flutter_projet_tutore/views/auth/email_verification_screen.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale_ofThe_Buttom.dart';
import 'package:flutter_projet_tutore/views/La_Reservation_prosses/Locations.dart';
import 'package:flutter_projet_tutore/views/La_Reservation_prosses/rooms.dart';
import 'package:flutter_projet_tutore/views/La_Reservation_prosses/BookingPage.dart';
import 'package:flutter_projet_tutore/views/Settings_Pages/Profile_Settings_Screen.dart';
import 'package:flutter_projet_tutore/views/Settings_Pages/Phone_Verify_Screen.dart';
import 'package:flutter_projet_tutore/views/auth/ForgotPassword_screens.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user already has a saved token
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Initial route based on login state
      initialRoute: isLoggedIn ? '/home' : '/register',

      getPages: [
        // ── Auth ────────────────────────────────────────────────────────
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/verify-email',
          page: () => const EmailVerificationScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/forgot-password/verify',
          page: () => const VerifyResetCodeScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/forgot-password/reset',
          page: () => const ResetPasswordScreen(),
          transition: Transition.rightToLeft,
        ),

        // ── Main ────────────────────────────────────────────────────────
        GetPage(
          name: '/home',
          page: () => const MyWidget(),
          transition: Transition.fadeIn,
        ),

        // ── Reservation flow ─────────────────────────────────────────────
        GetPage(
          name: '/locations',
          page: () => LocationsScreen(),
          transition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: '/rooms',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return RoomsScreen(
              locationId: args['locationId'] as int,
              locationName: args['locationName'] as String,
            );
          },
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/booking',
          page: () => RoomBookingPage(
            room: Get.arguments as Map<String, dynamic>,
          ),
          transition: Transition.rightToLeft,
        ),

        // ── Settings ────────────────────────────────────────────────────
        GetPage(
          name: '/settings/account',
          page: () => const AccountSettingsScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/settings/phone-verify',
          page: () => const PhoneVerifyScreen(),
          transition: Transition.rightToLeft,
        ),
      ],
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
// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // Still loading the auth state
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         final User? user = snapshot.data;

//         // ── Not logged in → Sign Up screen ──────────────────────────────
//         if (user == null) {
//           return const RegisterScreen();
//         }

//         // ── Logged in but email NOT verified → blocking gate ────────────
//         if (!user.emailVerified) {
//           return const VerifyEmailScreen();
//         }

//         // ── Logged in and verified → Home ────────────────────────────────
//         return MyWidget();
//       },
//     );
//   }
// }
