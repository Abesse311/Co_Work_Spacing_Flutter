import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:flutter_projet_tutore/variable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/core/helper/deeplinkScreen/bottom_bar.dart';
import 'package:flutter_projet_tutore/core/helper/deeplinkScreen/detail_card.dart';

/// Full-screen booking confirmation page shown when a [coworking://book?…]
/// deep link is received.
///
/// Expected [Get.arguments] is a Map<String,String> with:
///   room_id, room_name, location_name, booking_type_name,
///   total_price, date, start_time, end_time
class DeepLinkBookingPage extends StatefulWidget {
  const DeepLinkBookingPage({super.key});

  @override
  State<DeepLinkBookingPage> createState() => _DeepLinkBookingPageState();
}

class _DeepLinkBookingPageState extends State<DeepLinkBookingPage>
    with SingleTickerProviderStateMixin {
  static const _storage = FlutterSecureStorage();

  late final Map<String, String> _params;
  late final int    _roomId;
  late final String _roomName;
  late final String _locationName;
  late final String _bookingTypeName;
  late final double _totalPrice;
  late final String _date;
  late final String _displayDate;
  late final String _startTime;
  late final String _endTime;

  bool _isLoading = false;

  late final AnimationController _animCtrl;
  late final Animation<double>   _fadeAnim;
  late final Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();

    _params          = Map<String, String>.from(Get.arguments as Map);
    _roomId          = int.tryParse(_params['room_id'] ?? '') ?? 0;
    _roomName        = _params['room_name'] ?? '';
    _locationName    = _params['location_name'] ?? '';
    _bookingTypeName = _params['booking_type_name'] ?? '';
    _totalPrice      = double.tryParse(_params['total_price'] ?? '') ?? 0.0;
    _date            = _params['date'] ?? '';
    
    String tempDisplayDate = _date;
    final lowerType = _bookingTypeName.toLowerCase();
    if (lowerType.contains('week') || lowerType.contains('semaine')) {
      try {
        final parsed = DateTime.parse(_date);
        final end = parsed.add(const Duration(days: 4));
        final endStr = '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
        tempDisplayDate = '$_date\n$endStr';
      } catch (_) {}
    }
    _displayDate = tempDisplayDate;

    _startTime       = _params['start_time'] ?? '';
    _endTime         = _params['end_time'] ?? '';

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── API call ──────────────────────────────────────────────────────────────

  Future<void> _confirmBooking() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      AppSnackbar.error('Error', 'Not authenticated. Please log in.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Fetch booking types to resolve booking_type_name -> booking_type_id
      final typesResponse = await http.get(
        Uri.parse('$ngrok_url/rooms/$_roomId/booking-types'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (typesResponse.statusCode != 200) {
        setState(() => _isLoading = false);
        AppSnackbar.error(
          'Booking Failed',
          'Could not retrieve booking types for this room (${typesResponse.statusCode}).',
        );
        return;
      }

      final List<dynamic> typesData = jsonDecode(typesResponse.body);
      final matchedType = typesData.firstWhere(
        (t) {
          final name = (t['name'] as String? ?? '').toLowerCase();
          return name == _bookingTypeName.toLowerCase() ||
                 name.contains(_bookingTypeName.toLowerCase()) ||
                 _bookingTypeName.toLowerCase().contains(name);
        },
        orElse: () => null,
      );

      if (matchedType == null) {
        setState(() => _isLoading = false);
        AppSnackbar.error(
          'Booking Failed',
          'Could not find booking type matching "$_bookingTypeName" for this room.',
        );
        return;
      }

      final int bookingTypeId = matchedType['id'] as int;

      // 2. Submit the booking request using the resolved booking_type_id
      final response = await http.post(
        Uri.parse('$ngrok_url/bookings'),
        headers: {
          'Content-Type':  'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'booking_type_id':   bookingTypeId,
          'date':              _date,
          'start_time':        _startTime,
          'end_time':          _endTime,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackbar.success(
          'Booking Confirmed ',
          'Your reservation has been submitted!',
        );
        Get.offAllNamed('/home');
      } else {
        final body = _tryDecode(response.body);
        String msg = 'Booking failed (${response.statusCode}).';
        
        final detail = body['detail'];
        if (detail != null) {
          if (detail is String) {
            msg = detail;
          } else if (detail is List) {
            try {
              msg = detail.map((e) {
                if (e is Map && e.containsKey('msg')) {
                  final loc = e['loc'] is List ? (e['loc'] as List).join('.') : '';
                  return loc.isNotEmpty ? '$loc: ${e['msg']}' : '${e['msg']}';
                }
                return e.toString();
              }).join(', ');
            } catch (_) {
              msg = detail.toString();
            }
          } else {
            msg = detail.toString();
          }
        } else if (body['error'] != null) {
          msg = body['error'].toString();
        }

        final lower = msg.toLowerCase();
        if (lower.contains('téléphone') ||
            lower.contains('telephone') ||
            lower.contains('numéro') ||
            lower.contains('numero')) {
          msg = 'Please verify your phone number in settings before booking.';
        } else if (response.statusCode == 402 ||
            lower.contains('solde') ||
            lower.contains('insuffisant')) {
          msg = 'Insufficient balance. Please top up your account.';
        } else if (lower.contains('plage horaire') ||
            lower.contains("n'est pas disponible") ||
            lower.contains('not available') ||
            lower.contains('chevauchement') ||
            lower.contains('overlap') ||
            lower.contains('already booked') ||
            lower.contains('déjà réserv')) {
          msg = TKeys.slotUnavailable.tr;
        }
        AppSnackbar.error('Booking Failed', msg);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      AppSnackbar.error('Error', 'Connection error: $e');
    }
  }

  static Map<String, dynamic> _tryDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Booking request'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('Booking Details'),
                  const SizedBox(height: 12),
                  DetailCard(
                    locationName:    _locationName,
                    roomName:        _roomName,
                    bookingTypeName: _bookingTypeName,
                    date:            _displayDate,
                    startTime:       _startTime,
                    endTime:         _endTime,
                    totalPrice:      _totalPrice,
                    divider:         _divider(),
                  ),
                  const SizedBox(height: 24),
                  _InfoNote(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        isLoading: _isLoading,
        onCancel:  () => Get.back(),
        onConfirm: _confirmBooking,
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
          letterSpacing: 0.8,
        ),
      );

  Widget _divider() => const Divider(height: 1, indent: 20, endIndent: 20);
}

// ── Info note ─────────────────────────────────────────────────────────────────

class _InfoNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:        Colors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: Colors.amber.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This booking was prepared by an AI assistant based on available '
              'slots. Please review all details carefully before confirming.',
              style: TextStyle(
                fontSize: 12,
                color:    Colors.grey[700],
                height:   1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
