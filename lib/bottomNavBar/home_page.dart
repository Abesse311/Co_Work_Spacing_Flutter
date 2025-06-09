import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/pages/Locations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Room data list
  final List<Map<String, dynamic>> rooms = [
    {
      "title": "Salle de réunion",
      "subtitle": "oran sénia",
      "image": "img/Salles/sallederunion.jpeg",
      "rating": "4.9",
    },
    {
      "title": "Salle de conférence",
      "subtitle": "oran usto",
      "image": "img/Salles/conferance.jpeg",
      "rating": "4.9",
    },
    {
      "title": "Salle de formation",
      "subtitle": "oran",
      "image": "img/Salles/formation.jpeg",
      "rating": "4.9",
    },
    {
      "title": "Salle de réunion",
      "subtitle": "31",
      "image": "img/Salles/runion_deux.jpeg",
      "rating": "4.9",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 46, 104, 69),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_rounded, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text("Home", style: TextStyle(fontSize: 24, color: Colors.white)),
          ],
        ),
        centerTitle: true,
      ),

      //================================================= BODY =================================================//
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom styled headline instead of Card
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                "Your fresh and comfortable Space",
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 46, 104, 69),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: Offset(1, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 15),
            // Search bar and filter button
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Now',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Book your room now button
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.08),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Color.fromARGB(255, 46, 104, 69).withOpacity(0.12),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  LocationsScreen(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("icons/choose.png",height: 20,width: 20,)
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Book your room now',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 46, 104, 69),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Recommended section
            Text(
              'Recommended for You',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 15),

            // Room list with ListView.builder
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final room = rooms[index];
                  return GestureDetector(
                    onTap: () {
                      // Different action for each room
                      if (index == 0) {
                        // Action for first room
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped Salle de réunion')),
                        );
                      } else if (index == 1) {
                        // Action for second room
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped Salle de conférence')),
                        );
                      } else if (index == 2) {
                        // Action for third room
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped Salle de formation')),
                        );
                      } else if (index == 3) {
                        // Action for fourth room
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Tapped Salle de réunion 31')),
                        );
                      }
                    },
                    child: Container(
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
                              room["image"],
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
                                  room["title"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  room["subtitle"],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Rating
                          Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  room["rating"],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
