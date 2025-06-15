import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schools/controllers/address_controller.dart';

import '../controllers/schools_controller.dart';

class SchoolsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchoolController>(() => SchoolController());
  }
}

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
