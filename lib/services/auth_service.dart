import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/variables.dart';

/// Low-level HTTP client for all auth endpoints.
/// Every method returns a plain Map<String, dynamic> so controllers
/// stay decoupled from HTTP concerns.
///
/// The returned map always contains:
///   'success'    → bool
///   'statusCode' → int   (use this in controllers for specific error handling)
///   'message'    → String (server message or generic fallback)
///   'token'      → String? (when the server returns one)
class AuthService {
  // ── Endpoints ──────────────────────────────────────────────────────────────
  static Uri get _signupUrl =>
      Uri.parse('$ngrok_url/auth/local/signup');

  static Uri get _confirmEmailUrl =>
      Uri.parse('$ngrok_url/auth/local/confirm-email');

  static Uri get _loginUrl =>
      Uri.parse('$ngrok_url/auth/local/login');

  static Uri get _firebaseAuthUrl =>
      Uri.parse('$ngrok_url/auth/firebase');

  static Uri get _phoneSendCodeUrl =>
      Uri.parse('$ngrok_url/me/phone/send-code');

  static Uri get _phoneVerifyCodeUrl =>
      Uri.parse('$ngrok_url/me/phone/verify-code');

  static Uri get _forgotPasswordUrl =>
      Uri.parse('$ngrok_url/auth/local/forgot-password');

  static Uri get _verifyResetCodeUrl =>
      Uri.parse('$ngrok_url/auth/local/verify-reset-code');

  static Uri get _resetPasswordUrl =>
      Uri.parse('$ngrok_url/auth/local/reset-password');

  // ── Default headers ────────────────────────────────────────────────────────
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ── SIGN UP ────────────────────────────────────────────────────────────────
  /// POST /auth/local/signup
  /// Backend errors:
  ///   400 → Email already used
  ///   500 → Email sending failed
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            _signupUrl,
            headers: _headers,
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── CONFIRM EMAIL ──────────────────────────────────────────────────────────
  /// POST /auth/local/confirm-email
  /// Backend errors:
  ///   400 → No code found / user data not found
  ///   401 → Invalid code
  static Future<Map<String, dynamic>> confirmEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http
          .post(
            _confirmEmailUrl,
            headers: _headers,
            body: jsonEncode({'email': email, 'code': code}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── LOGIN ──────────────────────────────────────────────────────────────────
  /// POST /auth/local/login
  /// Backend errors:
  ///   400 → Account uses a different provider (Google)
  ///   401 → Wrong email or password
  ///   403 → Email not verified
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            _loginUrl,
            headers: _headers,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── GOOGLE / FIREBASE AUTH ─────────────────────────────────────────────────
  /// POST /auth/firebase
  /// Sends the Firebase ID token; backend verifies it and returns a local JWT.
  /// Backend errors:
  ///   401 → Invalid Firebase token
  static Future<Map<String, dynamic>> googleSignIn({
    required String firebaseToken,
  }) async {
    try {
      final response = await http
          .post(
            _firebaseAuthUrl,
            headers: _headers,
            body: jsonEncode({'firebase_token': firebaseToken}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── PHONE VERIFICATION ─────────────────────────────────────────────────────
  /// POST /me/phone/send-code
  /// Backend errors:
  ///   401 → Token invalid/expired
  ///   404 → User not found
  ///   409 → Phone number already used
  static Future<Map<String, dynamic>> sendPhoneCode({
    required String phone,
    required String token,
  }) async {
    try {
      final response = await http
          .post(
            _phoneSendCodeUrl,
            headers: {
              ..._headers,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'phone': phone}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  /// POST /me/phone/verify-code
  /// Backend errors:
  ///   400 → No pending code for this number
  ///   401 → Token invalid/expired OR invalid SMS code
  ///   403 → Code belongs to a different user
  ///   404 → User not found
  static Future<Map<String, dynamic>> verifyPhoneCode({
    required String phone,
    required String code,
    required String token,
  }) async {
    try {
      final response = await http
          .post(
            _phoneVerifyCodeUrl,
            headers: {
              ..._headers,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'phone': phone, 'code': code}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── PROFILE ────────────────────────────────────────────────────────────────
  /// GET /me
  /// Fetches the profile details of the currently authenticated user.
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$ngrok_url/me'),
        headers: {
          ..._headers,
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return {
          'success': true,
          'statusCode': 200,
          'data': jsonDecode(response.body) as Map<String, dynamic>,
        };
      }
      return {
        'success': false,
        'statusCode': response.statusCode,
        'message': 'Failed to load profile',
      };
    } on TimeoutException {
      return _timeoutError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── UPDATE PASSWORD & EMAIL ────────────────────────────────────────────────
  /// PUT /me/password
  /// Backend errors:
  ///   401 → Token invalid/expired OR wrong old password
  ///   404 → User not found
  static Future<Map<String, dynamic>> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$ngrok_url/me/password'),
            headers: {
              ..._headers,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'old_password': oldPassword,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  /// POST /me/email/request
  /// Backend errors:
  ///   401 → Token invalid/expired
  ///   404 → User not found
  ///   409 → Email already used
  ///   500 → Email sending failed
  static Future<Map<String, dynamic>> requestEmailUpdate({
    required String newEmail,
    required String token,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$ngrok_url/me/email/request'),
            headers: {
              ..._headers,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'new_email': newEmail}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  /// POST /me/email/confirm
  /// Backend errors:
  ///   400 → No pending email change request
  ///   401 → Token invalid/expired OR invalid code
  ///   404 → User not found
  static Future<Map<String, dynamic>> confirmEmailUpdate({
    required String code,
    required String token,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$ngrok_url/me/email/confirm'),
            headers: {
              ..._headers,
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'code': code}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── PASSWORD RECOVERY ──────────────────────────────────────────────────────
  /// POST /auth/local/forgot-password
  /// Backend errors:
  ///   404 → No user found with email
  ///   500 → Email sending failed
  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await http
          .post(
            _forgotPasswordUrl,
            headers: _headers,
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  /// POST /auth/local/verify-reset-code
  /// Backend errors:
  ///   400 → No reset code found for this email
  ///   401 → Invalid reset code
  static Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http
          .post(
            _verifyResetCodeUrl,
            headers: _headers,
            body: jsonEncode({'email': email, 'code': code}),
          )
          .timeout(const Duration(seconds: 60));

      final parsed = _parse(response);
      // Ensure reset token or general token from backend body is forwarded
      if (parsed['success'] == true) {
        try {
          final body = jsonDecode(response.body) as Map<String, dynamic>;
          parsed['reset_token'] = body['reset_token']?.toString() ?? body['token']?.toString() ?? '';
        } catch (_) {}
      }
      return parsed;
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  /// POST /auth/local/reset-password
  /// Backend errors:
  ///   400 → No reset authorization found for this email
  ///   401 → Invalid reset token
  ///   404 → User not found
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await http
          .post(
            _resetPasswordUrl,
            headers: _headers,
            body: jsonEncode({
              'email': email,
              'token': token,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 60));

      return _parse(response);
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return _unexpectedError(e);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Converts an [http.Response] into a standard result map.
  /// Controllers use [statusCode] for specific error branching.
  static Map<String, dynamic> _parse(http.Response response) {
    Map<String, dynamic> body = {};
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      // body is not valid JSON — keep empty map
    }

    final bool ok = response.statusCode >= 200 && response.statusCode < 300;

    return {
      'success': ok,
      'statusCode': response.statusCode,
      'message': body['message'] ??
          body['detail'] ??
          (ok ? 'Success' : 'Something went wrong (${response.statusCode}).'),
      if (body.containsKey('access_token')) 'token': body['access_token'],
      if (body.containsKey('token')) 'token': body['token'],
      if (body.containsKey('user_id')) 'user_id': body['user_id'],
      if (body.containsKey('id')) 'user_id': body['id'],
    };
  }

  static Map<String, dynamic> _networkError() => {
        'success': false,
        'statusCode': 0,
        'message': 'Network error. Please check your internet connection.',
      };

  static Map<String, dynamic> _timeoutError() => {
        'success': false,
        'statusCode': 0,
        'message': 'The server is starting up. Please wait a moment and try again.',
      };

  static Map<String, dynamic> _unexpectedError(Object e) => {
        'success': false,
        'statusCode': 0,
        'message': 'Unexpected error: $e',
      };
}
