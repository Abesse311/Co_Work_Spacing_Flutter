import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/settings_screen.dart';
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
import 'package:flutter_projet_tutore/views/Settings_Pages/Email_Change_Screen.dart';
import 'package:flutter_projet_tutore/views/auth/ForgotPassword_screens.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/app_translations.dart';
import 'package:flutter_projet_tutore/controllers/language_controller.dart';
import 'package:flutter_projet_tutore/services/deep_link_service.dart';
import 'package:flutter_projet_tutore/core/helper/deeplinkScreen/deep_link_booking_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user already has a saved token
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  final bool isLoggedIn = token != null && token.isNotEmpty;

  // Load persisted locale before building the widget tree
  final savedLocale = await LanguageController.initialLocale();

  runApp(MyApp(isLoggedIn: isLoggedIn, initialLocale: savedLocale));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Locale initialLocale;
  MyApp({super.key, required this.isLoggedIn, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: Locale('en', 'US'),
      // Register global services permanently for the entire app
      initialBinding: BindingsBuilder(() {
        Get.put(LanguageController(), permanent: true);
        Get.put(DeepLinkService(), permanent: true);
      }),

      // Initial route based on login state
      initialRoute: isLoggedIn ? '/home' : '/register',

      getPages: [
        // ── Auth ────────────────────────────────────────────────────────
        GetPage(
          name: '/login',
          page: () =>  LoginScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/verify-email',
          page: () =>  EmailVerificationScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/forgot-password',
          page: () =>  ForgotPasswordScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/forgot-password/verify',
          page: () =>  VerifyResetCodeScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/forgot-password/reset',
          page: () =>  ResetPasswordScreen(),
          transition: Transition.rightToLeft,
        ),

        // ── Main ────────────────────────────────────────────────────────
        GetPage(
          name: '/home',
          page: () =>  MyWidget(),
          transition: Transition.fadeIn,
        ),

        // ── Reservation flow ─────────────────────────────────────────────
        GetPage(
          name: '/locations',
          page: () => LocationsScreen(),
          transition: Transition.fade,
          transitionDuration:  Duration(milliseconds: 400),
        ),
        GetPage(
          name: '/rooms',
          page: () {
            final args = Get.arguments as Map<String, dynamic>;
            return RoomsScreen(
              locationId:   args['locationId']   as int,
              locationName: args['locationName'] as String,
              openingTime:  args['openingTime']  as String? ?? '08:00',
              closingTime:  args['closingTime']  as String? ?? '20:00',
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
          name: '/settings',
          page: () =>  SettingsScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/settings/account',
          page: () =>  AccountSettingsScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/settings/phone-verify',
          page: () =>  PhoneVerifyScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/settings/email-change',
          page: () =>  EmailChangeScreen(),
          transition: Transition.rightToLeft,
        ),

        // ── Deep Link Booking Page ────────────────────────────────────────
        GetPage(
          name: '/deep-link-booking',
          page: () => const DeepLinkBookingPage(),
          transition: Transition.downToUp,
          transitionDuration: const Duration(milliseconds: 400),
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
