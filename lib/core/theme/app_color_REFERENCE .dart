import 'package:flutter/material.dart';

class AppTheme {
  //################"####################"===================  COLORS
  static const Color primary = Color(0xFF1582DF);   // #1582DF
  static const Color primaryLight = Color(0xFF4DA3F5);
  static const Color primaryDark = Color(0xFF0F5FA8);

  static const Color background = Color(0xFFF5F7FA);
  static const Color card = Colors.white;

  static const Color textPrimary = Color(0xFF000000); // 0xFF000000
  static const Color textSecondary = Color(0xFF242424);  // 0xFF242424

  static const Color border = Color(0xFF1582DF);

  static const Color bottomNavBg = Color(0xFF2E2D2D);
  static const Color bottomNavInactive = Color(0xFFB0B0B0);

  //===================>>  GRADIENT (الهيدر)
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0F5FA8), Color(0xFF1582DF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  //===================>>  LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Poppins',

      // 🎨 Color Scheme
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: primaryLight,
        background: background,
      ),

      scaffoldBackgroundColor: background,

      // 📱 AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'roboto',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),

      //===================>>  TEXT THEME
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),

        headlineMedium: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),

        bodyLarge: TextStyle(
          fontFamily: 'roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),

        bodyMedium: TextStyle(
          fontFamily: 'roboto',
          fontSize: 14,
          color: primary,
        ),
        
        labelLarge: TextStyle(
          fontFamily: 'Exo2',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),

      //===================>>  Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      //===================>>  Outlined Button (مثل الفلاتر)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: Color.fromARGB(255, 253, 253, 253), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
      ),

      //===================>>  INPUT (Search / Fields)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        border: OutlineInputBorder(
        
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: primary),
        ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(30),
        //   borderSide: const BorderSide(color: primary, width: 2),
        // ),
      ),


      // ===================>>  Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bottomNavBg,
        selectedItemColor: primary,
        unselectedItemColor: bottomNavInactive,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      //===================>>  Icons
      iconTheme: const IconThemeData(color: primary, size: 24),
    );
  }
}
