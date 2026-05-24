import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/variables.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignIn_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/reservation_model.dart';

class ReservationsController extends GetxController {
  final reservations = <Reservation>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    isLoading.value = true;

    final token = await Auth_SignIn_Controller.getToken();
    if (token == null || token.isEmpty) return;

    try {
      final response = await http.get(
        Uri.parse('${ngrok_url}/reservations'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        reservations.value = data.map((item) => Reservation.fromJson(item)).toList();
      } else {
        Get.snackbar('Erreur', 'Impossible de charger les réservations');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Problème de connexion');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancels a reservation by booking_id — DELETE /cancel/{bookingId}
  Future<void> cancelReservation(Reservation reservation) async {
    // Client-side 24h guard (belt-and-suspenders)
    if (!reservation.canCancel) {
      _snack(
        'Cannot Cancel',
        'Cancellations must be made at least 24 hours before the reservation start time.',
        isError: true,
      );
      return;
    }

    // Confirm dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel Reservation'),
        content: Text(
          'Are you sure you want to cancel your reservation for "${reservation.title}"?\n\n'
          'You will receive a 50% refund.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No, keep it'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('Yes, cancel', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final token = await Auth_SignIn_Controller.getToken();
    if (token == null || token.isEmpty) {
      _snack('Not Authenticated', 'Please log in again.');
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('${ngrok_url}/cancel/${reservation.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final body = _safeDecodeBody(response.body);

      if (response.statusCode == 200) {
        _snack('Cancelled', 'Your reservation has been cancelled. 50% refunded.', isError: false);
        await fetchReservations(); // refresh the list
      } else if (response.statusCode == 409) {
        _snack('Too Late', body['error'] ?? 'Cannot cancel within 24h of the start time.');
      } else if (response.statusCode == 403) {
        _snack('Access Denied', body['error'] ?? 'This reservation does not belong to you.');
      } else if (response.statusCode == 404) {
        _snack('Not Found', body['error'] ?? 'Reservation not found.');
      } else if (response.statusCode == 400) {
        _snack('Already Cancelled', body['error'] ?? 'This reservation is already cancelled.');
      } else if (response.statusCode == 401) {
        _snack('Unauthorized', 'Your session has expired. Please log in again.');
      } else {
        _snack('Error', body['error'] ?? body['detail'] ?? 'Failed to cancel reservation.');
      }
    } catch (_) {
      _snack('Connection Error', 'Please check your internet connection and try again.');
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────
  Map<String, dynamic> _safeDecodeBody(String body) {
    try {
      return json.decode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  void _snack(String title, String message, {bool isError = true}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      backgroundColor: isError
          ? const Color(0xFFAA2213).withValues(alpha: 0.9)
          : const Color(0xFF2E6845).withValues(alpha: 0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}