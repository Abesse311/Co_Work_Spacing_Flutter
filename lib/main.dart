import 'package:flutter/material.dart';
//import 'package:flutter_projet_tutore/pages/register.dart';
import 'package:flutter_projet_tutore/pages/singUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),

    );
  }
}
