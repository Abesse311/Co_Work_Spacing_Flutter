import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Called when user taps "I have verified"
  /// Forces a reload of the Firebase user to get the latest emailVerified status.
  Future<void> checkEmailVerified() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        // No user session → send back to Sign Up
        Get.offAllNamed('/register');
        return;
      }

      // Force-reload user from Firebase to get the latest emailVerified value
      await user.reload();
      final User? refreshedUser = _auth.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        //  Email verified  to Home screen
        Get.offAllNamed('/login');
      } else {
        //  Not yet verified → stay and inform the user
        Get.snackbar(
          'Not Verified',
          'Your email is not verified yet. Please check your inbox.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'An error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Called when user taps "Resend email"
  /// Sends a new verification email with rate-limit guard.
  Future<void> resendVerificationEmail() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        Get.offAllNamed('/register');
        return;
      }

      if (user.emailVerified) {
        // Already verified, just proceed
        Get.offAllNamed('/home');
        return;
      }

      await user.sendEmailVerification();

      Get.snackbar(
        'Email Sent',
        'A new verification email has been sent to ${user.email}.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        Get.snackbar(
          'Too Many Requests',
          'Please wait a moment before requesting another email.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Error',
          e.message ?? 'Failed to resend verification email.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Called when user taps "Logout"
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/register');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
