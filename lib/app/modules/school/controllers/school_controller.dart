import 'package:get/get.dart';
import 'package:tbc_application/app/modules/assets/models/asset.dart';
import 'package:tbc_application/app/modules/school/views/widgets/supervisor_section/supervisors_section.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';

class SchoolDetailsController extends GetxController {


  Rx<School> school = Rx<School>(Get.arguments as School);
  Rx<Address?> address = Rx<Address?>(null);

  var num = 1.obs;
  RxList<Asset> assets = <Asset>[].obs;
  RxList<Supervisor> supervisors = <Supervisor>[].obs;
  RxList<Supervisor> contractors = <Supervisor>[].obs;

  @override
  void onInit() {
    loadInformation(); 
    super.onInit();
  }

  void loadInformation() async {
    assets.value = await Asset(maintenances: []).get();
  }

  void addSupervisors() {
    Get.dialog(
      WorkScopDialog(),
      barrierDismissible: false,
    ).then((value) {
      if (value!= null && value is Supervisor) {
        supervisors.add(value);
      }
    });
  }

  void addAssets() {
    Get.dialog(
      AssetTypesDialog(),
      barrierDismissible: false,
    ).then((value) {
      if (value!= null && value is Asset) {
        assets.add(value);
      }
    });
  }
  
  void add(Asset asset) {

    num.value += 1;
  }

  void remove(Asset asset) {
    num.value = num.value >= 1 ? num.value - 1 : 0;
  }
}
