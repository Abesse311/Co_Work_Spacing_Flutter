import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/bottomNavBar/home_page.dart';
import 'package:flutter_projet_tutore/bottomNavBar/pricipale.dart';
import 'package:flutter_projet_tutore/bottomNavBar/balance.dart';
import 'package:flutter_projet_tutore/pages/Locations.dart';
import 'package:flutter_projet_tutore/pages/sginUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        //scaffoldBackgroundColor: Colors.white,
      ),
      home: MyWidget(),

    );
  }
}
