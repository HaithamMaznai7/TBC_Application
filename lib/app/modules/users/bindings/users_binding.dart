import 'package:get/get.dart';
import 'package:tbc_application/app/modules/users/controllers/users_controller.dart';

class UsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
  }
}
