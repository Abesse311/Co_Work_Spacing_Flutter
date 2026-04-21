import 'package:flutter/material.dart';
import 'package:flutter_projet_tutore/controllers/bottomNavBar_conrollers/HomePage_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/helper/room_Tile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    onTap: controller.goToLocations,
                    child: Container(
                      padding: EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "icons/choose.png",
                        height: 20,
                        width: 20,
                      ),
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
            Text(
              'Suggested for you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  RommTile(title: "salle de runion", subtitle: "maravale", img_path: "img/Salles/sallederunion.jpeg", price: 800),
                  RommTile(title: "salle de runion", subtitle: "maravale", img_path: "img/Salles/formation.jpeg", price: 800),
                  RommTile(title: "salle de runion", subtitle: "maravale", img_path: "img/Salles/runion_deux.jpeg", price: 800),
                  RommTile(title: "salle de runion", subtitle: "maravale", img_path: "img/Salles/conferance.jpeg", price: 800),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}