import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/auth/sginUp.dart';
import 'package:flutter_projet_tutore/views/bottomNavBar/principale.dart';
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
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        //scaffoldBackgroundColor: Colors.white,
      ),
      home: MyWidget(),

    );
  }
}
