import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_projet_tutore/core/helper/forHomePage/room_Tile.dart';
import 'package:flutter_projet_tutore/core/helper/forHomePage/amenity_Tile.dart';
import 'package:flutter_projet_tutore/core/theme/app_theme.dart';
import 'package:flutter_projet_tutore/core/localization/translation_keys.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // physics:  BouncingScrollPhysics(),
        // _____________________________________________ image + text 
        child: Column(
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
                    TKeys.homeTagline.tr,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(height: 1.2),
                  ),
                ),
              ],
            ),
 
          
             SizedBox(height: 6),
             // _____________________________________________ book a room (boxbutton)

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed("/locations");
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 6,vertical: 8),
                  decoration: BoxDecoration(
                    gradient:  LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.primary, Color(0xFF3F8F5E)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE2A84B).withValues(alpha: 0.25), //  AppTheme.primary.withValues(alpha: 0.25)
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset:  Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Lottie.asset("animation/five.json",height: 60,width: 90),
                      // SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              TKeys.bookNow.tr,
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 16.5,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                             SizedBox(height: 4),
                            Text(
                              TKeys.bookNowSubtitle.tr,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

             SizedBox(height: 6),

            // _____________________________________________ Premium Amenities Row 

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics:  BouncingScrollPhysics(),
                  children: [
                    AmenityTile(icon: Icons.wifi_rounded, label: TKeys.fastWifi.tr),
                    AmenityTile(icon: Icons.volume_off_rounded, label: TKeys.quietZone.tr),
                    AmenityTile(icon: Icons.coffee_rounded, label: TKeys.freeCoffee.tr),
                    AmenityTile(
                      icon: Icons.access_time_filled_rounded,
                      label: TKeys.access247.tr,
                    ),
                  ],
                ),
              ),
            ),

             SizedBox(height: 18),

            // ______________________________________________ Explore Room Types Section 

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    TKeys.exploreRoomTypes.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    TKeys.swipeLeft.tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),

             SizedBox(height: 16),

            // ______________________________________________ Room Horizontal Suggestion List 
            SizedBox(
              height: 290,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(right: 20),
                children: [
                  RommTile(
                    title: TKeys.courseRoom.tr,
                    subtitle: TKeys.courseRoomCapacity.tr,
                    img_path: "img/ForHome/formation.jpg",
                    description: TKeys.courseRoomDesc.tr,
                  ),
                  RommTile(
                    title: TKeys.conferenceRoom.tr,
                    subtitle: TKeys.conferenceRoomCapacity.tr,
                    img_path: "img/ForHome/Conference.jpg",
                    description: TKeys.conferenceRoomDesc.tr,
                  ),
                  RommTile(
                    title: TKeys.teleconferenceRoom.tr,
                    subtitle: TKeys.teleconferenceRoomCapacity.tr,
                    img_path: "img/ForHome/tele.jpg",
                    description: TKeys.teleconferenceRoomDesc.tr,
                  ),
                  RommTile(
                    title: TKeys.meetingRoom.tr,
                    subtitle: TKeys.meetingRoomCapacity.tr,
                    img_path: "img/ForHome/meeting room.jpg",
                    description: TKeys.meetingRoomDesc.tr,
                  ),
                  RommTile(
                    title: TKeys.openSpace.tr,
                    subtitle: TKeys.openSpaceCapacity.tr,
                    img_path: "img/ForHome/openSpace.jpg",
                    description: TKeys.openSpaceDesc.tr,
                  ),
                  RommTile(
                    title: TKeys.privateOffice.tr,
                    subtitle: TKeys.privateOfficeCapacity.tr,
                    img_path: "img/ForHome/private office.jpg",
                    description: TKeys.privateOfficeDesc.tr,
                  ),
                ],
              ),
            ),
             SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
