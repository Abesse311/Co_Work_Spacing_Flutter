import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Singleton GetX service that listens for [coworking://book?...] deep links.
///
/// Lifecycle:
///   1. [onInit] is called once at app start (registered in main.dart bindings).
///   2. [_handleUri] determines whether the user is authenticated.
///      - YES → navigates to [/deep-link-booking] full-screen page.
///      - NO  → stores the params as a pending link and redirects to /register.
///              After a successful login, the login controller calls
///              [DeepLinkService.triggerPendingIfAny] to open the page.
///
/// Handles both:
///   • Cold-start  → [_appLinks.getInitialLink]
///   • Warm / hot  → [_appLinks.uriLinkStream]
class DeepLinkService extends GetxService {
  static const _storage = FlutterSecureStorage();

  /// Pending params saved when the user is not authenticated at link arrival.
  Map<String, String>? _pendingParams;

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Future<void> onInit() async {
    super.onInit();
    _appLinks = AppLinks();
    await _initLinks();
  }

  @override
  void onClose() {
    _linkSub?.cancel();
    super.onClose();
  }

  // ── Initialization ────────────────────────────────────────────────────────

  Future<void> _initLinks() async {
    // ── Cold-start: app was launched FROM a deep link ─────────────────────
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        // Wait for the widget tree to finish mounting before navigating.
        await Future.delayed(const Duration(milliseconds: 800));
        await _handleUri(initialUri);
      }
    } catch (_) {}

    // ── Warm / hot start: app already running ─────────────────────────────
    _linkSub = _appLinks.uriLinkStream.listen(
      (uri) async => await _handleUri(uri),
      onError: (_) {}, // silently ignore stream errors
    );
  }

  // ── URI handling ──────────────────────────────────────────────────────────

  Future<void> _handleUri(Uri uri) async {
    print("🌍 DEEP LINK RECEIVED: $uri");
    
    // Only react to: coworking://book?...
    if (uri.scheme != 'coworking' || uri.host != 'book') {
      print("❌ Scheme/Host mismatch. Scheme: ${uri.scheme}, Host: ${uri.host}");
      return;
    }

    final params = _extractParams(uri);
    if (params.isEmpty) {
      print("❌ Missing parameters. Query: ${uri.queryParameters}");
      Get.snackbar(
        "Deep Link Error",
        "Missing required parameters. Check console.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor:Colors.green,
        colorText:  Color.fromARGB(255, 219, 9, 9),
      );
      return;
    }

    print("✅ Deep link accepted! Checking auth...");

    final token           = await _storage.read(key: 'auth_token');
    final isAuthenticated = token != null && token.isNotEmpty;

    if (isAuthenticated) {
      // If we are on an auth screen, go home first so the booking page has
      // a proper back-stack to return to.
      final currentRoute = Get.currentRoute;
      if (currentRoute == '/register' || currentRoute == '/login') {
        Get.offAllNamed('/home');
        await Future.delayed(const Duration(milliseconds: 500));
      }
      Get.toNamed('/deep-link-booking', arguments: params);
    } else {
      // Store and redirect to login
      _pendingParams = params;
      Get.offAllNamed('/register', arguments: {'fromDeepLink': true});
    }
  }

  // ── Pending link replay (called by auth controllers after login) ──────────

  /// Call this from [Auth_SignIn_Controller] (and Google flow) after a
  /// successful sign-in to replay any deep link that arrived while logged out.
  Future<void> triggerPendingIfAny() async {
    final pending = _pendingParams;
    if (pending == null) return;
    _pendingParams = null;

    await Future.delayed(const Duration(milliseconds: 600));
    Get.toNamed('/deep-link-booking', arguments: pending);
  }

  // ── Parameter extraction ──────────────────────────────────────────────────

  Map<String, String> _extractParams(Uri uri) {
    final q = uri.queryParameters;
    print("🔍 Parsed query parameters: $q");

    // Require at minimum: room_id, date, start_time, end_time
    if (!q.containsKey('room_id') ||
        !q.containsKey('date') ||
        !q.containsKey('start_time') ||
        !q.containsKey('end_time')) {
      print("❌ Missing required parameters in deep link!");
      Get.snackbar(
        "Link Cut Off by Terminal",
        "Android only received: ${q.keys.join(', ')}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
        duration: const Duration(seconds: 10),
      );
      return {};
    }

    return {
      'room_id':           q['room_id']!,
      'room_name':         q['room_name'] ?? '',
      'location_name':     q['location_name'] ?? '',
      'booking_type_name': q['booking_type_name'] ?? '',
      'total_price':       q['total_price'] ?? '0',
      'date':              q['date']!,
      'start_time':        q['start_time']!,
      'end_time':          q['end_time']!,
    };
  }

  // ── Static convenience getter ─────────────────────────────────────────────

  static DeepLinkService get to => Get.find<DeepLinkService>();
}
