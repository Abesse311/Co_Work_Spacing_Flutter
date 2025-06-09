import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomsScreen extends StatefulWidget {
  final LocationData location;
  const RoomsScreen({Key? key, required this.location}) : super(key: key);

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<RoomData> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/rooms/${widget.location.id}'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        rooms = data.map((item) => RoomData.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms in ${widget.location.name}'),
        backgroundColor: Color.fromARGB(255, 37, 77, 53),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 228, 228, 228),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Room image
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.asset(
                              room.image,
                              width: 120,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12),
                          // Room details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  room.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  room.subtitle,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.people,
                                      size: 16,
                                      color: Colors.green[700],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Capacity: ${room.capacity}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
    );
  }
}

class RoomData {
  final int id;
  final String name;
  final String subtitle;
  final String image;
  final int capacity;

  RoomData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.capacity,
  });

  factory RoomData.fromJson(Map<String, dynamic> json) {
    return RoomData(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      image: json['image'],
      capacity: json['capacity'],
    );
  }
}

// Dummy LocationData class (replace with your real one if needed)
class LocationData {
  final int id;
  final String name;
  final String imageAsset;
  LocationData({
    required this.id,
    required this.name,
    required this.imageAsset,
  });
}
