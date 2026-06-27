import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages the active locale and persists it across app restarts.
/// Inject once at app startup via [Get.put].
class LanguageController extends GetxController {
  static const _prefKey = 'app_locale';

  // Observable: 'en' or 'fr'
  final currentLang = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  // ── Public API ───────────────────────────────────────────────────────────────

  bool get isFrench => currentLang.value == 'fr';

  /// Call this to switch locale and persist the choice.
  Future<void> changeLanguage(String langCode) async {
    if (currentLang.value == langCode) return;
    currentLang.value = langCode;
    final locale = langCode == 'fr' ?  Locale('fr', 'FR') :  Locale('en', 'US');
    Get.updateLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, langCode);
  }

  // ── Private ──────────────────────────────────────────────────────────────────

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'en';
    currentLang.value = saved;
    final locale = saved == 'fr' ?  Locale('fr', 'FR') :  Locale('en', 'US');
    Get.updateLocale(locale);
  }

  /// Returns the [Locale] to pass as [GetMaterialApp.locale] on first build
  /// (before onInit fires). Falls back to English.
  static Future<Locale> initialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'en';
    return saved == 'fr' ? const Locale('fr', 'FR') : const Locale('en', 'US');
  }
}
