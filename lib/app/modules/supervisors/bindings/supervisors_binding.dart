import 'package:get/get.dart';

import '../controllers/supervisors_controller.dart';

class SupervisorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupervisorsController>(
      () => SupervisorsController(),
    );
  }
}
