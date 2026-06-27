import 'package:flutter/material.dart';

class RommTile extends StatelessWidget {
  final String title;
  final String subtitle; // Will hold the capacity range, e.g., "from 20 to 30"
  final String img_path;
  final String description;

  RommTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.img_path,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────────
            Stack(
              children: [
                Image.asset(
                  img_path,
                  width: double.infinity,
                  height: 125,
                  fit: BoxFit.cover,
                ),
                // Subtle gradient overlay at the bottom of the image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Text Content ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                   SizedBox(height: 6),
                  // Capacity range instead of location
                  Row(
                    children: [
                       Icon(
                        Icons.people_alt_rounded,
                        size: 14,
                        color: Color.fromARGB(255, 46, 104, 69),
                      ),
                      SizedBox(width: 2,),
                      Text("Capacity:"),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Description
                  Text(
                    description,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
