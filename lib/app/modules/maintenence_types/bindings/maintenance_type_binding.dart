import 'package:get/get.dart';

import '../controllers/maintenance_type_controller.dart';

class MaintenanceTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaintenanceTypeController>(() => MaintenanceTypeController());
  }
}
