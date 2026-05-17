import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/variables.dart';

/// Low-level HTTP client for all auth endpoints.
/// Every method returns a plain [Map<String, dynamic>] so controllers
/// stay decoupled from HTTP concerns.
class AuthService {
  // ── Endpoints ──────────────────────────────────────────────────────────────
  static Uri get _signupUrl =>
      Uri.parse('$ngrok_url/auth/local/signup');

  static Uri get _confirmEmailUrl =>
      Uri.parse('$ngrok_url/auth/local/confirm-email');

  static Uri get _loginUrl =>
      Uri.parse('$ngrok_url/auth/local/login');

  // ── Default headers ────────────────────────────────────────────────────────
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ── SIGN UP ────────────────────────────────────────────────────────────────
  /// POST /auth/local/signup
  /// Returns { 'success': bool, 'message': String }
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
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
              'phone': phoneNumber,
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
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  // ── CONFIRM EMAIL ──────────────────────────────────────────────────────────
  /// POST /auth/local/confirm-email
  /// Returns { 'success': bool, 'message': String }
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
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  // ── LOGIN ──────────────────────────────────────────────────────────────────
  /// POST /auth/local/login
  /// Returns { 'success': bool, 'message': String, 'token': String?,
  ///           'emailNotVerified': bool? }
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

      final parsed = _parse(response);

      // FastAPI may signal unverified email via a specific status / message
      if (response.statusCode == 403) {
        parsed['emailNotVerified'] = true;
      }

      // 401 = wrong email or password
      if (response.statusCode == 401) {
        parsed['wrongCredentials'] = true;
      }

      return parsed;
    } on TimeoutException {
      return _timeoutError();
    } on SocketException {
      return _networkError();
    } on HttpException {
      return _networkError();
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Converts an [http.Response] into a standard result map.
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
      // Prefer a server-supplied message; fall back to a generic one.
      'message': body['message'] ??
          body['detail'] ??
          (ok ? 'Success' : 'Something went wrong (${response.statusCode}).'),
      // Forward any token the server might return
      if (body.containsKey('access_token')) 'token': body['access_token'],
      if (body.containsKey('token')) 'token': body['token'],
      // Forward user_id if the server returns it
      if (body.containsKey('user_id')) 'user_id': body['user_id'],
      if (body.containsKey('id')) 'user_id': body['id'],
    };
  }

  static Map<String, dynamic> _networkError() => {
        'success': false,
        'message': 'Network error. Please check your internet connection.',
      };

  static Map<String, dynamic> _timeoutError() => {
        'success': false,
        'message':
            'The server is starting up. Please wait a moment and try again.',
      };
}
