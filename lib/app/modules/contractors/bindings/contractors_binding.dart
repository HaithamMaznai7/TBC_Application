import 'package:get/get.dart';

import '../controllers/contractors_controller.dart';

class ContractorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractorsController>(
      () => ContractorsController(),
    );
  }
}
