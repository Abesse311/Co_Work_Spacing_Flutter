import 'dart:convert'; /////////////////////////// 1
import 'package:flutter/material.dart';
// import 'package:flutter_projet_tutore/BookingPage.dart';
import 'package:flutter_projet_tutore/views/La_Reservation_prosses/BookingPage.dart';
import 'package:http/http.dart' as http;

class RoomsScreen extends StatefulWidget {
  final int locationId;
  final String locationName;

  const RoomsScreen({
    super.key,
    required this.locationId,
    required this.locationName,
  });

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<Room> rooms = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://ae3b-129-45-96-86.ngrok-free.app/rooms/by-location/${widget.locationName}',   //  <<<<<<<<<==================
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          rooms =
              data
                  .map(
                    (item) => Room(
                      id: item['id'],
                      name: item['name'],
                      price: double.parse(item['slot_price'].toString()),
                      address: '', // Ajoute l'adresse si dispo dans la réponse
                      imageBase64: item['image_base64'],
                      capacity: item['capacity'] ?? 0, // <-- Add this line
                    ),
                  )
                  .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.locationName} Rooms'),
        backgroundColor: Color.fromARGB(255, 37, 77, 53),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return RoomItem(room: room);
                },
              ),
    );
  }
}

class Room {
  final int id;
  final String name;
  final double price;
  final String address;
  final String? imageBase64;
  final int capacity; // <-- Add this field

  Room({
    required this.id,
    required this.name,
    required this.price,
    required this.address,
    this.imageBase64,
    required this.capacity, // <-- Add this parameter
  });
}

class RoomItem extends StatelessWidget {
  final Room room;

  const RoomItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => RoomBookingPage(
                  room: {
                    'id': room.id,
                    'name': room.name,
                    'slot_price': room.price,
                    'address': room.address,
                    'capacity': room.capacity, // <-- Pass capacity if needed
                  },
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
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
            if (room.imageBase64 != null)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.memory(
                  base64Decode(room.imageBase64!),
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
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
                      room.address,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      '${room.price} DZD/hour',
                      style: TextStyle(
                        color: Color.fromARGB(255, 46, 104, 69),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Capacity: ${room.capacity}', // <-- Show capacity here
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Location {
  final int id;
  final String name;

  Location({required this.id, required this.name});
}

// Exemple d'utilisation de la navigation avec les données de l'emplacement
void navigateToRoomsScreen(BuildContext context, Location location) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) =>
              RoomsScreen(locationId: location.id, locationName: location.name),
    ),
  );
}
