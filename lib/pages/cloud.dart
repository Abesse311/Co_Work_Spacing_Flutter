// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // النماذج
// class User {
//   final String id;
//   final String name;
//   final String email;
//   final String role;
//   double balance;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.role,
//     required this.balance,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'].toString(),
//       name: json['name'],
//       email: json['email'],
//       role: json['role'],
//       balance: double.parse(json['balance'].toString()),
//     );
//   }
// }

// class Location {
//   final String id;
//   final String name;

//   Location({required this.id, required this.name});

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['id'].toString(),
//       name: json['name'],
//     );
//   }
// }

// class Room {
//   final String id;
//   final String name;
//   final String locationId;
//   final int capacity;

//   Room({
//     required this.id,
//     required this.name,
//     required this.locationId,
//     required this.capacity,
//   });

//   factory Room.fromJson(Map<String, dynamic> json) {
//     return Room(
//       id: json['id'].toString(),
//       name: json['name'],
//       locationId: json['location_id'].toString(),
//       capacity: json['capacity'],
//     );
//   }
// }

// class Booking {
//   final String id;