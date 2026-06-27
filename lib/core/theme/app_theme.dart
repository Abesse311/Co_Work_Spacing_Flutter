import 'package:flutter/material.dart';

class AppTheme {

  // =================== COLORS
  static const Color primary = Color(0xFF2E6845); // Color.fromARGB(255, 46, 104, 69) and Color(0xFF2E6845)
  static const Color primaryDark = Color(0xFF254D35); // Color.fromARGB(255, 37, 77, 53)
  
  static const Color background = Color(0xFFFAF9F5);
  static const Color backgroundLight = Color(0xFFF5F5F5); // SignUp container bg
  static const Color backgroundBeige = Color(0xFFF5F5DC); // SignIn container bg
  
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.black54;
  static const Color textGrey = Colors.grey;
  
  static const Color errorLight = Colors.red;
  static const Color success = Colors.green;
  
  static const Color border = Color(0xFFE0E0E0); // Colors.grey[300] / Colors.grey.shade300
  
  static const Color bottomNavInactive = Color(0xFF787878); // Color.fromARGB(255, 120, 120, 120)

  // =================== CUSTOM DECORATIONS
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withValues(alpha: 0.1),
        spreadRadius: 1,
        blurRadius: 2,
        offset:  Offset(0, 1),
      ),
    ],
  );

  static BoxDecoration inputDecoration = BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(12),
  );

  // =================== LIGHT THEME
  static ThemeData get lightTheme {
    return ThemeData(

      scaffoldBackgroundColor: background,

      colorScheme:  ColorScheme.light(
        primary: primary,
        secondary: primary,
        error: errorLight,
        surface: background,
      ),

      ////////////////////////// AppBarTheme
      
      appBarTheme:  AppBarTheme(
        backgroundColor: primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: "Relicta"
        ),
      ),

      ////////////////////////// TextTeheme
      
      textTheme:  TextTheme(
        ///////////////=############### signin/signup/ homePage////////////////
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "Relicta"
        ),

        ///////////////////////////////
        
        headlineSmall: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        ///////////////=############### Suggested for you (homePage)////////////////
        
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        ///////////////=############### For the elevated buttons <<<=====
        
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: "Relicta"
        ),
        ///////////////=############### have an account
        
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontFamily: "roboto"
        ),
        ///////////////////////////////
        
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Color(0xFF757575),  // 0xCCFFFFFF
        ),
        //////////////////=############### forgot password 
        
        labelLarge: TextStyle(
          fontSize: 16,
          color: Colors.black54,
          fontFamily: "exo"
        ),
      ),

      ////////////////////////// ElevatedButton
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding:  EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      ////////////////////////// InputDecoration
      
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primary, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.black54),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),

      ////////////////////////// BottomNavigationBar
      
      bottomNavigationBarTheme:  BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primary,
        unselectedItemColor: bottomNavInactive,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),

      ////////////////////////// IconS
      
      iconTheme:  IconThemeData(
        color: primary,
      ),
    );
  }
}
