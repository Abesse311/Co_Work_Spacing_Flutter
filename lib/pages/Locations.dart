import 'package:flutter/material.dart';

class LocationsScreen extends StatefulWidget {
  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  // Sample data for the rooms
  final List<LocationData> locations = [
    LocationData(
      name: "Bir Eljir",
      imageAsset: "img/Locations/bir_eljir.jpg", // Replace with your asset path
    ),
    LocationData(
      name: "Es-senia",
      imageAsset: "img/Locations/senai.jpg", // Replace with your asset path
    ),
    LocationData(
      name: "Maravel",
      imageAsset: "img/Locations/maravale.jpg", // Replace with your asset path
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Locations"),
        backgroundColor: Color.fromARGB(255, 37, 77, 53),
      ),

      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Changed from direct ListView.builder to Column
          children: [
            Expanded(
              // Wrap ListView.builder with Expanded
              child: ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return RoomCard(
                    location: locations[index],
                    onTap: () {
                      // Here you can define a different action for each location
                      // For now, just print the location name
                      print('Clicked: ${locations[index].name}'); // TODO: ddjd
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300]!, width: 1.0),
              ),
              child: const Text(
                "Note: Tous nos emplacements disposent d'une salle de repos et d'une salle à manger.",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final LocationData location;
  final VoidCallback? onTap;
  const RoomCard({Key? key, required this.location, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            children: [
              // Background image - Replace with your actual asset
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Image.asset(
                  location.imageAsset,
                  fit: BoxFit.fill, // Change from cover to contain
                  // Removed errorBuilder
                ),
              ),
              // Bottom overlay with location info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Room name with location icon
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            location.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data model for location information
class LocationData {
  final String name;
  final String imageAsset;
  LocationData({required this.name, required this.imageAsset});
}
