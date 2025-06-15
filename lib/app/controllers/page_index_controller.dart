import 'package:get/get.dart';
import 'package:tbc_application/app/controllers/presence_controller.dart';
import 'package:tbc_application/app/routes/app_pages.dart';

class PageIndexController extends GetxController {
  final presenceController = Get.find<PresenceController>();
  RxInt pageIndex = 0.obs;

  void changePage(int index) async {
    pageIndex.value = index;

    switch (index) {
      case 1:
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        Get.offAllNamed(Routes.SCHEDULE);
        break;
      case 3:
        Get.offAllNamed(Routes.CITY_SCHOOLS);
        break;
      case 4:
        Get.offAllNamed(Routes.MORE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
        break;
    }
  }

  var showFabMenu = false.obs;

  void toggleFabMenu() => showFabMenu.toggle();

  void hideFabMenu() => showFabMenu.value = false;
}
