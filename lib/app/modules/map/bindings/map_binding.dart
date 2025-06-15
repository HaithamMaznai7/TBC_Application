import 'package:get/get.dart';
import 'package:tbc_application/app/modules/map/controllers/cities_school_controller.dart';

import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(
      () => MapController(),
    );
  }
}

class CitiesSchoolBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitiesSchoolController>(
      () => CitiesSchoolController(),
    );
  }
}
