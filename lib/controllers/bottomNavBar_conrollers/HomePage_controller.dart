import 'package:get/get.dart';
import 'package:flutter_projet_tutore/views/La_Reservation_prosses/Locations.dart';

// // // ================================>>>  this contains only the navigation in HomePage 

class HomeController extends GetxController {
  void goToLocations() {
    Get.to(
      () => LocationsScreen(),
      transition: Transition.fade,
      duration: Duration(milliseconds: 500),
    );
  }
}