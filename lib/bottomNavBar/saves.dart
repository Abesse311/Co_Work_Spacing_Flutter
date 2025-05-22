import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/bottomNavBar/settings.dart';

class SavesScreen extends StatefulWidget {
  const SavesScreen({Key? key}) : super(key: key);

  @override
  State<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends State<SavesScreen> {
  // List of data for each item
  final List<Map<String, dynamic>> savedItems = [
    {
      "title": "Salle de réunion",
      "subtitle": "Oran Sénia",
      "image": "img/sallederunion.jpeg",
      "rating": "4.9",
    },
    {
      "title": "salle de formaion",
      "subtitle": "Alger Hydra",
      "image": "img/runion_deux.jpeg",
      "rating": "4.7",
    },
    {
      "title": "salle to conférance",
      "subtitle": "Constantine Centre",
      "image": "img/conferance.jpeg",
      "rating": "4.8",
    },
    {
      "title": "Salle de formation",
      "subtitle": "Tlemcen Mansourah",
      "image": "img/formation.jpeg",
      "rating": "4.6",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 46, 104, 69),
        elevation: 0,
        title: const Text(
          'saves',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search Now",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {
                      // Filter logic removed
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: savedItems.length,
              itemBuilder: (context, index) {
                final item = savedItems[index];
                return GestureDetector(
                  onTap: () {
                    // Example: Navigate to SettingsScreen for the second item
                    if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
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
                        // Room image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Image.asset(
                            item["image"],
                            width: 120,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Room details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["subtitle"],
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
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item["rating"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
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
    );
  }
}
