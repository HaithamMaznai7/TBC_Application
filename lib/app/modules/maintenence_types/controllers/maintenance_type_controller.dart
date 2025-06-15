// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/maintenance_type_model.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/excel_service/excel_import.dart';
import 'package:tbc_application/app/excel_service/excel_export.dart';

class MaintenanceTypeController extends GetxController {

  var maintenanceTypes = <MaintenanceType>[].obs;
  var filteredMaintenanceTypes = <MaintenanceType>[].obs;
  var services = <String>[].obs;
  var selectedService = 'All'.obs;
  var isExporting = false.obs;
  var isImporting = false.obs;

  MaintenanceType? type;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadMaintenanceTypes();
  }

  void loadMaintenanceTypes() async {
    List<MaintenanceType> types = await MaintenanceType().get();
    maintenanceTypes.value = types;
    updateServices(types);
    filterByService('All');
  }

  void updateServices(List<MaintenanceType> types) {
    services.value = types.where((element) => element.service != null).toList().map((t) => t.service!).toSet().toList();
  }

  void filterByService(String service) {
    selectedService.value = service;
    if (service == 'All') {
      filteredMaintenanceTypes.value = List.from(maintenanceTypes);
    } else {
      filteredMaintenanceTypes.value = maintenanceTypes.where((t) => t.service == service).toList();
    }
  }

  void addMaintenanceType() {
    Get.toNamed(Routes.ADD_MAINTENANCE_TYPES_FEATURE);
  }

  void editMaintenanceType(MaintenanceType type) async {
    Get.toNamed(Routes.ADD_MAINTENANCE_TYPES_FEATURE, arguments: type);
  }

  void deleteMaintenanceType(MaintenanceType type) async {
    type.delete();
    loadMaintenanceTypes();
  }

  void importFromExcel() async {
    isImporting.toggle();

    final import = ImportController<MaintenanceType>(
      headers: MaintenanceType.excelFileHeaders,
      fromCsvRow: (Map<String, dynamic> map) => MaintenanceType.fromMap(map),
    );

    final importedItems = await import.importFromFile();
    print('Importing from Excel...');
    print(importedItems.length);
    for (var item in importedItems) {
      print(item);
      await item.save();
    }
    print('Finish Importing from Excel');

    loadMaintenanceTypes();
    isImporting.toggle();
  }

  void exportToExcel() {
    isExporting.toggle();

    final export = ExportController<MaintenanceType>(
      headers: MaintenanceType.excelFileHeaders,
      toCsvRow: (MaintenanceType item) => item.toCsvRow(),
    );

    export.exportToCsv(maintenanceTypes, 'Maintenance_Types_Export');
    isExporting.toggle();
  }

  void loadMaintenanceTypeData(String id) async {
    type = await MaintenanceType().find(id);
    nameController.text = type?.name ?? '';
    serviceController.text = type?.service ?? '';
    unitController.text = type?.unit ?? '';
    frequencyController.text = type?.frequency.toString() ?? '';
    
  }

  void addNewMaintenanceType() async {
    if(type == null || type?.id == null){
      type = MaintenanceType();
      
    }

    type!.name = nameController.text;
    type!.service = serviceController.text;
    type!.unit = unitController.text;
    type!.frequency = int.parse(frequencyController.text);
    await type!.save();
    
    loadMaintenanceTypes();
    Get.back();
  }
}
