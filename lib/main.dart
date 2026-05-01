import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/auth/sginUp.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
//import 'package:flutter_projet_tutore/pages/sgin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        textTheme: AppTheme.lightTheme.textTheme.apply(fontFamily: 'SF Pro Display'),
      ),
      home: MyWidget(),
    );
  }
}
