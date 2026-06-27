import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/variable.dart';
import 'package:flutter_projet_tutore/controllers/auth_controller/SignIn_controller.dart';
import 'package:flutter_projet_tutore/core/helper/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/reservation_model.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';

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
        AppSnackbar.error(TKeys.error.tr, TKeys.failedLoadReservations.tr);
      }
    } catch (e) {
      AppSnackbar.error(TKeys.error.tr, TKeys.connectionProblem.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancels a reservation by booking_id — DELETE /cancel/{bookingId}
  Future<void> cancelReservation(Reservation reservation) async {
    // Client-side 24h guard (belt-and-suspenders)
    if (!reservation.canCancel) {
      AppSnackbar.error(TKeys.cannotCancel.tr, TKeys.cancel24hRule.tr);
      return;
    }

    // Confirm dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(TKeys.cancelReservation.tr),
        content: Text(
          TKeys.cancelConfirmMsg.tr.replaceAll('@title', reservation.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(TKeys.noKeepIt.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: Text(TKeys.yesCancel.tr, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final token = await Auth_SignIn_Controller.getToken();
    if (token == null || token.isEmpty) {
      AppSnackbar.error(TKeys.notAuthenticated.tr, TKeys.pleaseLogInAgain.tr);
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('${ngrok_url}/cancel/${reservation.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final body = _safeDecodeBody(response.body);

      if (response.statusCode == 200) {
        AppSnackbar.success(TKeys.cancelledTitle.tr, TKeys.reservationCancelled50.tr);
        await fetchReservations(); // refresh the list
      } else if (response.statusCode == 409) {
        AppSnackbar.error(TKeys.tooLate.tr, body['error'] ?? TKeys.cannotCancel24h.tr);
      } else if (response.statusCode == 403) {
        AppSnackbar.error(TKeys.accessDenied.tr, body['error'] ?? TKeys.reservationNotYours.tr);
      } else if (response.statusCode == 404) {
        AppSnackbar.error(TKeys.notFound.tr, body['error'] ?? TKeys.reservationNotFound.tr);
      } else if (response.statusCode == 400) {
        AppSnackbar.error(TKeys.alreadyCancelled.tr, body['error'] ?? TKeys.reservationAlreadyCancelled.tr);
      } else if (response.statusCode == 401) {
        AppSnackbar.error(TKeys.unauthorized.tr, TKeys.sessionExpired.tr);
      } else {
        AppSnackbar.error(TKeys.error.tr, body['error'] ?? body['detail'] ?? TKeys.failedCancelReservation.tr);
      }
    } catch (_) {
      AppSnackbar.error(TKeys.connectionError.tr, TKeys.checkInternetConnection.tr);
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
}