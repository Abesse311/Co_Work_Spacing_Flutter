import 'package:get/get.dart';
import 'en_translations.dart';
import 'fr_translations.dart';

/// GetX [Translations] class that combines all locale maps.
/// Adding a new language: create a new `xx_translations.dart` map
/// and add an entry here under `'xx_XX'`

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enTranslations,
        'fr_FR': frTranslations,
      };
}
