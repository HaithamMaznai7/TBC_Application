import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/excel_service/excel_export.dart';
import 'package:tbc_application/app/excel_service/import.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class SchoolController extends GetxController {

  final firestore = FirebaseFirestore.instance;
  final collection = 'schools';

  var schools = <School>[].obs;
  var filteredSchools = <School>[].obs;
  var schoolGroups = <String>[].obs;
  var selectedGroup = 'All'.obs;
  var isImporting = false.obs;
  var isExporting = false.obs;

  School? school;
  TextEditingController nameController = TextEditingController();
  TextEditingController ministerialIDController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();

  Rx<SchoolLevel> selectedLevel = Rx<SchoolLevel>(SchoolLevel.primary);
  Rx<SchoolType> selectedType = Rx<SchoolType>(SchoolType.male);

  // Address Fields
  Rx<Address?> address = Rx<Address?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSchools();
  }

  void loadSchools() async {
    List<School> schoolList = await School().get();
    schools.value = schoolList;
    updateSchoolGroups(schoolList);
    filterByGroup('All');
  }

  void updateSchoolGroups(List<School> schoolList) {
    schoolGroups.value = schoolList.where((element) => element.group != null).toList().map((s) => s.group!).toSet().toList();
  }

  void filterByGroup(String group) {
    selectedGroup.value = group;
    if (group == 'All') {
      filteredSchools.value = List.from(schools);
    } else {
      filteredSchools.value = schools.where((s) => s.group == group).toList();
    }
  }

  void openSchool(School s) async {
    Get.toNamed(Routes.School_Info, arguments: s);
  }

  void openSchoolForm(School? s) async {
    school = s ?? School.empty();

    address.value = await school!.address();
    nameController.text = school?.name ?? '';
    ministerialIDController.text = school?.ministerialID ?? '';
    groupNameController.text = school?.group ?? '';
    selectedLevel.value = school!.level;
    selectedType.value = school!.type;
    
    Get.toNamed(Routes.ADD_SCHOOL);
  }

  void deleteSchool(School school) async {
    address.value = await school.address();
    await address.value?.delete();
    school.delete();
  }

  void saveSchool() async {
    school ??= School();

    if(address.value != null){
      address.value = await address.value!.save();
      // school!.addressID = address.value;
    }
    school!.name = nameController.text;
    school!.ministerialID = ministerialIDController.text;
    school!.group = groupNameController.text;
    school!.level = selectedLevel.value;
    school!.type =  selectedType.value;
    school = await school!.save();
    
    CustomToast.successToast('School Saved', 'The school has been saved successfully');
    loadSchools();
  }

  void importFromExcel() async {
    isImporting.toggle();

    final import = ImportProvider<School>(
      fromCsvRow: (data) => School.fromCsvRow(data),
    );

    final schools = await import.importFromFile();
    if (schools.isEmpty) {
      CustomToast.errorToast('Error', 'CSV is empty or invalid');
      isImporting.toggle();
      return;
    }

    for (School school in schools) {
      await school.save();
    }

    loadSchools();
    isImporting.toggle();
  }



  void exportToExcel() {
    isExporting.toggle();

    final export = ExportController<School>(
      headers: School.excelFileHeaders,
      toCsvRow: (School item) => item.toCsvRow(),
    );

    export.exportToCsv(schools, 'schools_Export');
    isExporting.toggle();
  }
}
