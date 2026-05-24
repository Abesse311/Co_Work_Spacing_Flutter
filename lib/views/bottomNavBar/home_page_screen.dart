import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/HomePage_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/helper/room_Tile.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Image.asset(
                "img/homepage.jpg",
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              ),
              Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Find a fresh and\ncomfortable space",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(                    
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),


          SizedBox(height: 10),
          //// container off book your room now 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: (){Get.toNamed("/locations",arguments: null);},
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "icons/choose.png",
                        height: 24,
                        width: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book your room now',
                            style: Theme.of(context).textTheme.headlineSmall
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Find the perfect space for you',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8))
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 15),
      
      
          //////////////////////////// liste of sugestions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Suggested for you',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 15),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  RommTile(
                    title: "salle de runion",
                    subtitle: "maravale",
                    img_path: "img/Salles/sallederunion.jpeg",
                    price: 800,
                  ),
                  RommTile(
                    title: "salle de runion",
                    subtitle: "maravale",
                    img_path: "img/Salles/formation.jpeg",
                    price: 800,
                  ),
                  RommTile(
                    title: "salle de runion",
                    subtitle: "maravale",
                    img_path: "img/Salles/runion_deux.jpeg",
                    price: 800,
                  ),
                  RommTile(
                    title: "salle de runion",
                    subtitle: "maravale",
                    img_path: "img/Salles/conferance.jpeg",
                    price: 800,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
