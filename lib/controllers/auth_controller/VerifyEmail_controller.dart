import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

class VerifyEmailController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkEmailVerified() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        Get.offAllNamed('/register');
        return;
      }
      await user.reload();
      final User? refreshedUser = _auth.currentUser;
      if (refreshedUser != null && refreshedUser.emailVerified) {
        Get.offAllNamed('/login');
      } else {
        AppSnackbar.error(TKeys.notVerified.tr, TKeys.emailNotVerifiedYet.tr);
      }
    } on FirebaseAuthException catch (e) {
      AppSnackbar.error(TKeys.error.tr, e.message ?? TKeys.anErrorOccurred.tr);
    } catch (e) {
      AppSnackbar.error(TKeys.error.tr, TKeys.unexpectedError.tr);
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) {
        Get.offAllNamed('/register');
        return;
      }
      if (user.emailVerified) {
        Get.offAllNamed('/home');
        return;
      }
      await user.sendEmailVerification();
      AppSnackbar.success(TKeys.emailSent.tr, TKeys.emailSentMsg.tr);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        AppSnackbar.error(TKeys.tooManyRequests.tr, TKeys.waitBeforeAnotherEmail.tr);
      } else {
        AppSnackbar.error(TKeys.error.tr, e.message ?? TKeys.failedResendVerification.tr);
      }
    } catch (e) {
      AppSnackbar.error(TKeys.error.tr, TKeys.unexpectedError.tr);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/register');
    } catch (e) {
      AppSnackbar.error(TKeys.error.tr, TKeys.failedLogout.tr);
    }
  }
}
