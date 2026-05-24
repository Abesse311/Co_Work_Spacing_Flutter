import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_projet_tutore/models/User_model.dart';
import 'package:flutter_projet_tutore/variables.dart';

import 'package:flutter_projet_tutore/models/transaction_history.dart';

class BalanceController extends GetxController {
  final currentUser = Rxn<User>();
  final transactions = <TransactionHistory>[].obs;
  final isLoading = true.obs;

  static const _storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true;

    // Read the stored JWT token
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      return;
    }

    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Fetch user data and balance history concurrently
      final futures = await Future.wait([
        http.get(Uri.parse('$ngrok_url/me'), headers: headers),
        http.get(Uri.parse('$ngrok_url/me/balance-history'), headers: headers),
      ]);

      final userResponse = futures[0];
      final historyResponse = futures[1];

      if (userResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        currentUser.value = User.fromJson(userData);
      } else {
        Get.snackbar('Erreur', 'Failed to load user data (${userResponse.statusCode})');
      }

      if (historyResponse.statusCode == 200) {
        final List<dynamic> historyData = json.decode(historyResponse.body);
        transactions.value = historyData.map((data) => TransactionHistory.fromJson(data)).toList();
        // Sort from newest to oldest if not already sorted
        transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        print('Failed to load history: ${historyResponse.body}');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données');
    } finally {
      isLoading.value = false;
    }
  }
}
