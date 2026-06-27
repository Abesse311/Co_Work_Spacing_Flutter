import 'package:get/get.dart';

/// Central registry of all localization keys used across the app.
/// Always reference these constants instead of raw strings to avoid typos.
abstract class TKeys {
  // ── Common ──────────────────────────────────────────────────────────────────
  static const error              = 'error';
  static const success            = 'success';
  static const cancel             = 'cancel';
  static const close              = 'close';
  static const later              = 'later';
  static const disconnect         = 'disconnect';
  static const anErrorOccurred   = 'an_error_occurred';
  static const unexpectedError   = 'unexpected_error';

  // ── Bottom Nav ───────────────────────────────────────────────────────────────
  static const navHome     = 'nav_home';
  static const navBalance  = 'nav_balance';
  static const navBookings = 'nav_bookings';
  static const navSettings = 'nav_settings';

  // ── Auth – Sign In ───────────────────────────────────────────────────────────
  static const logInBtn                 = 'log_in_btn';
  static const signUpBtn                = 'sign_up_btn';
  static const continueWithGoogleBtn    = 'continue_with_google_btn';
  static const dontHaveAccount          = 'dont_have_account';
  static const alreadyHaveAccount       = 'already_have_account';
  static const registerBtn              = 'register_btn';
  
  static const emptyFields              = 'empty_fields';
  static const pleaseEnterEmailPassword = 'please_enter_email_password';
  static const invalidEmail             = 'invalid_email';
  static const pleaseEnterValidEmail    = 'please_enter_valid_email';
  static const welcomeBack              = 'welcome_back';
  static const youAreNowSignedIn        = 'you_are_now_signed_in';
  static const wrongSignInMethod        = 'wrong_sign_in_method';
  static const thisAccountUsesGoogle    = 'this_account_uses_google';
  static const thisAccountUsesEmailPassword = 'this_account_uses_email_password';
  static const loginFailed              = 'login_failed';
  static const incorrectEmailOrPassword = 'incorrect_email_or_password';
  static const failedFirebaseToken      = 'failed_firebase_token';
  static const signInFailed             = 'sign_in_failed';
  static const googleSignInFailed       = 'google_sign_in_failed';
  static const authenticationError      = 'authentication_error';

  // ── Phone Dialog ─────────────────────────────────────────────────────────────
  static const phoneNumberRequired = 'phone_number_required';
  static const phoneRequiredMessage = 'phone_required_message';
  static const addPhone             = 'add_phone';

  // ── Auth – Sign Up ────────────────────────────────────────────────────────────
  static const fillAllRequiredFields          = 'fill_all_required_fields';
  static const weakPassword                   = 'weak_password';
  static const passwordMin8Chars              = 'password_min_8_chars';
  static const emailAlreadyUsed               = 'email_already_used';
  static const emailAlreadyExists             = 'email_already_exists';
  static const invalidData                    = 'invalid_data';
  static const checkInputsTryAgain            = 'check_inputs_try_again';
  static const emailError                     = 'email_error';
  static const couldNotSendVerificationEmail  = 'could_not_send_verification_email';
  static const signUpFailed                   = 'sign_up_failed';

  // ── Auth – Forgot Password ────────────────────────────────────────────────────
  static const emptyField                  = 'empty_field';
  static const pleaseEnterEmailAddress     = 'please_enter_email_address';
  static const codeSent                    = 'code_sent';
  static const verificationCodeSent        = 'verification_code_sent';
  static const userNotFound                = 'user_not_found';
  static const noUserRegisteredEmail       = 'no_user_registered_email';
  static const failedSendResetEmail        = 'failed_send_reset_email';
  static const resetFailed                 = 'reset_failed';
  static const sendCodeBtn                 = 'send_code_btn';
  static const verifyCodeBtn               = 'verify_code_btn';
  static const resetPasswordBtn            = 'reset_password_btn';
  static const couldNotSendCode            = 'could_not_send_code';
  static const pleaseEnterVerificationCode = 'please_enter_verification_code';
  static const codeVerified                = 'code_verified';
  static const pleaseChooseNewPassword     = 'please_choose_new_password';
  static const expiredCode                 = 'expired_code';
  static const noActiveResetRequest        = 'no_active_reset_request';
  static const invalidCode                 = 'invalid_code';
  static const verificationCodeIncorrect   = 'verification_code_incorrect';
  static const verificationFailed          = 'verification_failed';
  static const fillBothPasswordFields      = 'fill_both_password_fields';
  static const mismatch                    = 'mismatch';
  static const passwordsDoNotMatch         = 'passwords_do_not_match';
  static const passwordResetSuccess        = 'password_reset_success';
  static const passwordResetSuccessMsg     = 'password_reset_success_msg';
  static const accessDenied                = 'access_denied';
  static const noActiveResetPermission     = 'no_active_reset_permission';
  static const invalidResetToken           = 'invalid_reset_token';
  static const resetTokenInvalid           = 'reset_token_invalid';
  static const userAccountNotFound         = 'user_account_not_found';
  static const failedResetPassword         = 'failed_reset_password';

  // ── Email Verification ───────────────────────────────────────────────────────
  static const notVerified              = 'not_verified';
  static const emailNotVerifiedYet      = 'email_not_verified_yet';
  static const emailSent                = 'email_sent';
  static const emailSentMsg             = 'email_sent_msg';
  static const tooManyRequests          = 'too_many_requests';
  static const waitBeforeAnotherEmail   = 'wait_before_another_email';
  static const failedResendVerification = 'failed_resend_verification';
  static const failedLogout             = 'failed_logout';
  static const missingCode              = 'missing_code';
  static const enterCodeSentEmail       = 'enter_code_sent_email';
  static const emailVerified            = 'email_verified';
  static const accountConfirmedSignIn   = 'account_confirmed_sign_in';
  static const codeExpired              = 'code_expired';
  static const noCodeFoundEmail         = 'no_code_found_email';
  static const wrongCode                = 'wrong_code';
  static const codeIncorrectCheckInbox  = 'code_incorrect_check_inbox';

  // ── Reservations ─────────────────────────────────────────────────────────────
  static const reservationTitle          = 'reservation_title';
  static const myReservations            = 'my_reservations';
  static const confirmed                 = 'confirmed';
  static const cancelled                 = 'cancelled';
  static const noReservations            = 'no_reservations';
  static const locationPrefix            = 'location_prefix';
  static const reservationTypePrefix     = 'reservation_type_prefix';
  static const reservationDatePrefix     = 'reservation_date_prefix';
  static const timePrefix                = 'time_prefix';
  static const failedLoadReservations    = 'failed_load_reservations';
  static const connectionProblem         = 'connection_problem';
  static const cannotCancel              = 'cannot_cancel';
  static const cancel24hRule             = 'cancel_24h_rule';
  static const cancelReservation         = 'cancel_reservation';
  static const cancelConfirmMsg          = 'cancel_confirm_msg';
  static const noKeepIt                  = 'no_keep_it';
  static const yesCancel                 = 'yes_cancel';
  static const notAuthenticated          = 'not_authenticated';
  static const pleaseLogInAgain          = 'please_log_in_again';
  static const cancelledTitle            = 'cancelled_title';
  static const reservationCancelled50   = 'reservation_cancelled_50';
  static const tooLate                   = 'too_late';
  static const cannotCancel24h           = 'cannot_cancel_24h';
  static const reservationNotYours       = 'reservation_not_yours';
  static const notFound                  = 'not_found';
  static const reservationNotFound       = 'reservation_not_found';
  static const alreadyCancelled          = 'already_cancelled';
  static const reservationAlreadyCancelled = 'reservation_already_cancelled';
  static const unauthorized              = 'unauthorized';
  static const sessionExpired            = 'session_expired';
  static const failedCancelReservation   = 'failed_cancel_reservation';
  static const connectionError           = 'connection_error';
  static const checkInternetConnection   = 'check_internet_connection';
  static const failedLoadData            = 'failed_load_data';

  // ── Settings ─────────────────────────────────────────────────────────────────
  static const settings              = 'settings';
  static const accountSettings       = 'account_settings';
  static const accountSubtitle       = 'account_subtitle';
  static const notifications         = 'notifications';
  static const allowNotifications    = 'allow_notifications';
  static const notificationsSubtitle = 'notifications_subtitle';
  static const help                  = 'help';
  static const helpSubtitle          = 'help_subtitle';
  static const contactUs             = 'contact_us';
  static const logOut                = 'log_out';
  static const logoutSubtitle        = 'logout_subtitle';
  static const confirmDisconnect     = 'confirm_disconnect';
  static const language              = 'language';
  static const languageSubtitle      = 'language_subtitle';
  static const selectLanguage        = 'select_language';
  static const english               = 'english';
  static const french                = 'french';

  // ── Home ─────────────────────────────────────────────────────────────────────
  static const homeTagline      = 'home_tagline';
  static const bookNow          = 'book_now';
  static const bookNowSubtitle  = 'book_now_subtitle';
  static const fastWifi         = 'fast_wifi';
  static const quietZone        = 'quiet_zone';
  static const freeCoffee       = 'free_coffee';
  static const access247        = 'access_247';
  static const exploreRoomTypes = 'explore_room_types';
  static const swipeLeft        = 'swipe_left';
  static const capacity         = 'capacity';

  // ── Room Types ───────────────────────────────────────────────────────────────
  static const courseRoom                 = 'course_room';
  static const courseRoomCapacity         = 'course_room_capacity';
  static const courseRoomDesc             = 'course_room_desc';

  static const conferenceRoom             = 'conference_room';
  static const conferenceRoomCapacity     = 'conference_room_capacity';
  static const conferenceRoomDesc         = 'conference_room_desc';

  static const teleconferenceRoom         = 'teleconference_room';
  static const teleconferenceRoomCapacity = 'teleconference_room_capacity';
  static const teleconferenceRoomDesc     = 'teleconference_room_desc';

  static const meetingRoom                = 'meeting_room';
  static const meetingRoomCapacity        = 'meeting_room_capacity';
  static const meetingRoomDesc            = 'meeting_room_desc';

  static const openSpace                  = 'open_space';
  static const openSpaceCapacity          = 'open_space_capacity';
  static const openSpaceDesc              = 'open_space_desc';
  
  static const privateOffice              = 'private_office';
  static const privateOfficeCapacity      = 'private_office_capacity';
  static const privateOfficeDesc          = 'private_office_desc';

  // ── Booking ──────────────────────────────────────────────────────────────────
  static const chooseReservationType = 'choose_reservation_type';
  static const reservationTypes      = 'reservation_types';
  static const noBookingTypes        = 'no_booking_types';
  static const confirmBooking        = 'confirm_booking';
  static const reserved              = 'reserved';
  static const selected              = 'selected';
  static const weekRange             = 'week_range';
  static const theSlots              = 'the_slots';
  static const selectTimeSlots       = 'select_time_slots';
  static const byHour                = 'by_hour';
  static const byHalfDay             = 'by_half_day';
  static const byDay                 = 'by_day';
  static const byWeek                = 'by_week';
  static const confirmAction         = 'confirm_action';
  static const priceLabel            = 'price_label';
  static const confirmQuestion       = 'confirm_question';
  static const slotUnavailable       = 'slot_unavailable';

  static String translateBookingType(String name) {
    final clean = name.trim().toLowerCase();
    if (clean.contains('hour') || clean.contains('heure')) {
      return TKeys.byHour.tr;
    }
    if (clean.contains('half') || clean.contains('demi')) {
      return TKeys.byHalfDay.tr;
    }
    if (clean.contains('week') || clean.contains('semaine')) {
      return TKeys.byWeek.tr;
    }
    if (clean.contains('day') || clean.contains('jour')) {
      return TKeys.byDay.tr;
    }
    return name;
  }

  // ── Locations ────────────────────────────────────────────────────────────────
  static const locationsTitle = 'locations_title';
  static const locationsNote  = 'locations_note';
  // ── Balance Screen ───────────────────────────────────────────────────────
  static const currentBalance       = 'current_balance';
  static const howToRecharge        = 'how_to_recharge';
  static const importantInfo        = 'important_info';
  static const chargeInstructions   = 'charge_instructions';
  static const transactionHistory   = 'transaction_history';
  static const txRoomBooking        = 'tx_room_booking';
  static const txCancellationRefund = 'tx_cancellation_refund';
  static const txBalanceRecharge    = 'tx_balance_recharge';
  static const copied               = 'copied';
  static const copiedMsg            = 'copied_msg';
  static const algeriePoste         = 'algerie_poste';
  static const account              = 'account';
  static const name                 = 'name';
  static const firstName            = 'first_name';
  static const address              = 'address';
  static const rip                  = 'rip';

  // ── Profile / Account Settings ───────────────────────────────────────────────
  static const accountSettingsTitle         = 'account_settings_title';
  static const personalInformation          = 'personal_information';
  static const nameField                    = 'name_field';
  static const accountInformation           = 'account_information';
  static const emailField                   = 'email_field';
  static const passwordField                = 'password_field';
  static const setAPassword                 = 'set_a_password';
  static const phoneField                   = 'phone_field';
  static const notVerifiedField             = 'not_verified_field';
  static const changeBtn                    = 'change_btn';
  static const verifyBtn                    = 'verify_btn';

  // ── Phone Verification ───────────────────────────────────────────────────────
  static const verifyPhoneNumberTitle       = 'verify_phone_number_title';
  static const phoneVerificationHeader      = 'phone_verification_header';
  static const phoneVerificationDesc        = 'phone_verification_desc';
  static const phoneNumberLabel             = 'phone_number_label';
  static const enterPhoneNumberHint         = 'enter_phone_number_hint';
  static const sendVerificationCodeBtn      = 'send_verification_code_btn';
  static const verificationCodeLabel        = 'verification_code_label';
  static const enterCodeHint                = 'enter_code_hint';
  static const verifyPhoneBtn               = 'verify_phone_btn';
  static const resendCodeBtn                = 'resend_code_btn';
  static const changeNumberBtn              = 'change_number_btn';

  // ── Email Change ─────────────────────────────────────────────────────────────
  static const changeEmailTitle             = 'change_email_title';
  static const changeEmailHeader            = 'change_email_header';
  static const changeEmailDesc              = 'change_email_desc';
  static const newEmailLabel                = 'new_email_label';
  static const enterNewEmailHint            = 'enter_new_email_hint';
  static const enter6DigitCodeHint          = 'enter_6_digit_code_hint';
  static const confirmEmailBtn              = 'confirm_email_btn';

  // ── Profile Settings Controller / Dialogs ────────────────────────────────────
  static const changePasswordTitle          = 'change_password_title';
  static const setPasswordTitle             = 'set_password_title';
  static const currentPasswordLabel         = 'current_password_label';
  static const newPasswordLabel             = 'new_password_label';
  static const confirmPasswordLabel         = 'confirm_password_label';
  static const saveBtn                      = 'save_btn';
  static const changeUsernameTitle          = 'change_username_title';
  static const usernameLabel                = 'username_label';
  static const enterNewUsernameHint         = 'enter_new_username_hint';

  static const userNotConnectedMsg          = 'user_not_connected_msg';
  static const youAreNotLoggedIn            = 'you_are_not_logged_in';
  static const passwordUpdatedSuccess       = 'password_updated_success';
  static const currentPasswordIncorrect     = 'current_password_incorrect';
  static const failedToUpdatePassword       = 'failed_to_update_password';
  static const pleaseEnterUsername          = 'please_enter_username';
  static const usernameUpdatedSuccess       = 'username_updated_success';
  static const failedToUpdateUsername       = 'failed_to_update_username';

  static const pleaseEnterNewEmail          = 'please_enter_new_email';
  static const verificationCodeSentToEmail  = 'verification_code_sent_to_email';
  static const emailAlreadyInUse            = 'email_already_in_use';
  static const failedToRequestEmailUpdate   = 'failed_to_request_email_update';
  static const emailUpdatedSuccess          = 'email_updated_success';
  static const noPendingEmailRequest        = 'no_pending_email_request';
  static const failedToVerifyNewEmail       = 'failed_to_verify_new_email';

  static const pleaseEnterPhoneNumber       = 'please_enter_phone_number';
  static const pleaseEnterValidPhoneNumber  = 'please_enter_valid_phone_number';
  static const verificationCodeSentToPhone  = 'verification_code_sent_to_phone';
  static const phoneAlreadyRegistered       = 'phone_already_registered';
  static const phoneVerifiedSuccess         = 'phone_verified_success';
  static const noPendingCodeForNumber       = 'no_pending_code_for_number';
  static const invalidSmsCode               = 'invalid_sms_code';
  static const verificationCodeBelongsToOther = 'verification_code_belongs_to_other';
  static const couldNotLocateUserProfile    = 'could_not_locate_user_profile';
  static const sessionExpiredOrInvalid      = 'session_expired_or_invalid';
  static const unexpectedErrorWithDetails   = 'unexpected_error_with_details';
  static const wrongPassword                = 'wrong_password';

  // ── Cancellation and Refund Policy ──────────────────────────────────────────
  static const cancellationRefundPolicy      = 'cancellation_refund_policy';
  static const cancellationRefundSubtitle    = 'cancellation_refund_subtitle';
  static const cancellationRefundContent     = 'cancellation_refund_content';
}
