import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projet_tutore/variables.dart';

class BookingController extends GetxController {
  final Map<String, dynamic> room;

  BookingController({required this.room});

  final availability = <Map<String, dynamic>>[].obs;
  final selectedDate = RxnString();
  final selectedStart = RxnString();
  final selectedEnd = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchAvailability();
  }

  Future<void> fetchAvailability() async {
    final now = DateTime.now();
    final start = now.toIso8601String().split('T')[0];
    final end =
        now.add(Duration(days: 6)).toIso8601String().split('T')[0];

    try {
      final response = await http.get(
        Uri.parse(
          '${ngrok_url}/rooms/${room['id']}/slots?start=$start&end=$end',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        List<Map<String, dynamic>> temp = [];
        data.forEach((date, slotsData) {
          List<Map<String, dynamic>> slots = [];
          for (var slot in slotsData['available_slots']) {
            slots.add({"slot": slot, "status": "available"});
          }
          for (var slot in slotsData['unavailable_slots']) {
            slots.add({"slot": slot, "status": "booked"});
          }
          slots.sort((a, b) => a['slot'].compareTo(b['slot']));
          temp.add({"date": date, "time_slots": slots});
        });
        availability.value = temp;
      } else {
        Get.snackbar('Erreur', 'Impossible de charger les créneaux');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Problème de connexion');
    }
  }

  void selectSlot(String date, String slot) {
    if (selectedDate.value != date) {
      selectedDate.value = date;
      selectedStart.value = slot;
      selectedEnd.value = null;
    } else if (selectedStart.value != null && selectedEnd.value == null) {
      int startHour = int.parse(selectedStart.value!.split(':')[0]);
      int currentHour = int.parse(slot.split(':')[0]);

      if (currentHour < startHour) {
        selectedEnd.value = selectedStart.value;
        selectedStart.value = slot;
      } else if (currentHour == startHour) {
        selectedStart.value = null;
        selectedDate.value = null;
      } else {
        selectedEnd.value = slot;
      }
    } else {
      selectedStart.value = slot;
      selectedEnd.value = null;
    }
  }

  Future<void> confirmReservation() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId == null || userId.isEmpty) {
      Get.snackbar('Erreur', 'Utilisateur non connecté');
      return;
    }

    int startHour = int.parse(selectedStart.value!.split(':')[0]);
    int endHour = int.parse(selectedEnd.value!.split(':')[0]);
    int slotCount = endHour - startHour;
    double slotPrice = room['slot_price'] is int
        ? (room['slot_price'] as int).toDouble()
        : room['slot_price'] ?? 0.0;
    double totalPrice = slotCount * slotPrice;

    bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirm Reservation'),
        content: Text(
          'Date: ${selectedDate.value}\n'
          'From: ${selectedStart.value} to ${selectedEnd.value}\n'
          'Number of slots: $slotCount\n'
          'Total amount: $totalPrice DZD\n\n'
          'Do you want to confirm this reservation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _sendReservation(userId, slotCount, totalPrice);
    }
  }

  Future<void> _sendReservation(
      String userId, int slotCount, double totalPrice) async {
    try {
      final response = await http.post(
        Uri.parse('${ngrok_url}/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": userId,
          "room_id": room['id'],
          "date": selectedDate.value,
          "start_time": selectedStart.value,
          "slot_count": slotCount,
        }),
      );
      print('🔍 POST /bookings → ${response.statusCode}: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Succès', 'Vous avez bien réservé !');
        fetchAvailability();
        selectedDate.value = null;
        selectedStart.value = null;
        selectedEnd.value = null;
      } else {
        final resp = jsonDecode(response.body);
        Get.snackbar('Erreur', resp['detail'] ?? resp['error'] ?? 'Erreur lors de la réservation');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Problème de connexion: $e');
    }
  }
}