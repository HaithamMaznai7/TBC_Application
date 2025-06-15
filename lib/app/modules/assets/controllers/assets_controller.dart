import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/assets/models/asset.dart';
import 'package:tbc_application/app/modules/maintenence_types/models/maintenance_type_model.dart';
import 'package:tbc_application/app/modules/school/views/widgets/supervisor_section/supervisors_section.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';
import 'package:tbc_application/app/routes/app_pages.dart';

class AssetsController extends GetxController {
  var assets = <Asset>[].obs;
  var maintenances = <MaintenanceType>[].obs;
  var filteredAssets = <Asset>[].obs;
Rx<WorkScop?> selectedType = Rx<WorkScop?>(WorkScop.none);
  
  // var isImporting = false.obs;
  // var isExporting = false.obs;

  Rx<Asset?> asset = Rx<Asset?>(null);
  TextEditingController nameController = TextEditingController();

  // Address Fields
  // Rx<Address?> address = Rx<Address?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAssets();
  }

  loadAssets() async{
    assets.value = await Asset(maintenances: []).get();
    assets.refresh();
  }

  openAssetsForm(Asset? newAsset) async {
    asset.value = newAsset ?? Asset(maintenances: []);
    asset.refresh();
    nameController.text = '${asset.value?.name}';
    selectedType.value = asset.value?.type;
    maintenances.value = await asset.value?.getMaintenances() ?? [];
    maintenances.refresh();
    Get.toNamed(Routes.ADD_ASSET);
  }

  void saveAsset() async {
    try{
      asset.value!.name = nameController.text;
      asset.value!.type = selectedType.value ?? WorkScop.none;
      
      await asset.value!.save();
      assets.refresh();
      Get.back();
    }catch(e) {
      print('Error saving asset: $e');
    }
  }


  void addMaintenances() {
    Get.dialog(
      MaintenanceTypesDialog(),
      barrierDismissible: false,
    ).then((value) {
      if (value!= null && value is List<MaintenanceType>) {
        maintenances.value = value;
        asset.value = asset.value ?? Asset(maintenances: []);
        asset.value!.maintenances = value.map((e) => MaintenanceType().collection.doc(e.id)).toList();
        asset.refresh();
        maintenances.refresh();
      }
    });
  }

  deleteAsset(Asset asset) async {
    try {
      await asset.delete();
      assets.refresh();
      loadAssets();
    } catch (e) {
      print('Error deleting asset: $e');
    }

  }
  
}
