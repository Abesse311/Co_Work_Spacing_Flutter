import 'package:flutter/material.dart';

class SavesScreen extends StatefulWidget {
  const SavesScreen({Key? key}) : super(key: key);

  @override
  State<SavesScreen> createState() => _SavesScreenState();
}

class _SavesScreenState extends State<SavesScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  // Exemple de données pour les espaces sauvegardés
  final List<Map<String, dynamic>> _savedSpaces = [
    {
      'title': 'Salle de réunion',
      'description': 'oran série',
      'rating': 4.9,
      'isSaved': true,
      'image': 'assets/images/meeting_room1.jpg',
    },
    {
      'title': 'Salle de conférence',
      'description': 'oran usto',
      'rating': 4.9,
      'isSaved': true,
      'image': 'assets/images/conference_room.jpg',
    },
    {
      'title': 'Salle de relaxation',
      'description': 'oran',
      'rating': 4.9,
      'isSaved': true,
      'image': 'assets/images/relaxation_room.jpg',
    },
    {
      'title': 'Salle de réunion',
      'description': '31',
      'rating': 4.9,
      'isSaved': true,
      'image': 'assets/images/meeting_room2.jpg',
    },
  ];

  List<Map<String, dynamic>> _filteredSpaces = [];

  @override
  void initState() {
    super.initState();
    _filteredSpaces = List.from(_savedSpaces);
    
    // Ajouter un listener pour la recherche
    _searchController.addListener(_filterSpaces);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtrer les espaces en fonction du texte de recherche
  void _filterSpaces() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      if (query.isEmpty) {
        _filteredSpaces = List.from(_savedSpaces);
      } else {
        _filteredSpaces = _savedSpaces
            .where((space) => 
                space['title'].toLowerCase().contains(query) ||
                space['description'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  // Gérer les clics sur les éléments sauvegardés
  void _handleSpaceTap(int index) {
    // À implémenter: Navigation vers la page de détails de l'espace
    print('Espace tapped: ${_filteredSpaces[index]['title']}');
    
    // Cette fonction serait appelée pour naviguer vers les détails
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SpaceDetailsScreen(space: _filteredSpaces[index]),
    //   ),
    // );
  }

  // Gérer le bouton de sauvegarde/désauvegarde
  void _toggleSave(int index) {
    setState(() {
      final spaceId = _filteredSpaces[index]['title'] + _filteredSpaces[index]['description'];
      
      // Trouver l'élément correspondant dans la liste originale
      final originalIndex = _savedSpaces.indexWhere((space) => 
          space['title'] + space['description'] == spaceId);
      
      if (originalIndex != -1) {
        _savedSpaces[originalIndex]['isSaved'] = !_savedSpaces[originalIndex]['isSaved'];
        _filteredSpaces[index]['isSaved'] = _savedSpaces[originalIndex]['isSaved'];
      }
    });
  }

  // Gérer le bouton filtre
  void _showFilterOptions() {
    // À implémenter: Afficher les options de filtrage
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filtrer par',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Évaluation (plus élevée)'),
                onTap: () {
                  // Logique de filtrage à implémenter
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Ordre alphabétique'),
                onTap: () {
                  // Logique de filtrage à implémenter
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Location'),
                onTap: () {
                  // Logique de filtrage à implémenter
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 46, 104, 69),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                      controller: _searchController,
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
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterOptions,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredSpaces.length,
              itemBuilder: (context, index) {
                final space = _filteredSpaces[index];
                return GestureDetector(
                  onTap: () => _handleSpaceTap(index),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Image.asset(
                              space['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                space['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                space['description'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    space['rating'].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            space['isSaved'] ? Icons.bookmark : Icons.bookmark_border,
                            color: space['isSaved'] ? Colors.black : Colors.grey,
                          ),
                          onPressed: () => _toggleSave(index),
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
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 2, // L'index 2 correspond à l'onglet "saves"
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bookmark),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: '',
      //     ),
      //   ],
      // ),
    );
  }
}