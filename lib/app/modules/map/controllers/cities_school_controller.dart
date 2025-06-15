import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/more/models/features.dart';
import 'package:tbc_application/app/modules/schools/models/city.dart';
import 'package:tbc_application/app/routes/app_pages.dart';

class CitiesSchoolController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var cities = <City>[].obs;
  var filteredCities = <City>[].obs;
  var regions = <String>[].obs;
  var selectedRegion = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadCities();
  }


  void loadCities() async {
    cities.value = await City.all();
    updateRegion(cities);
    filterByRegion('All');
  }

  void updateRegion(List<City> allCities) {
    regions.value = allCities.where((element) => element.region != null).toList().map((t) => t.region!).toSet().toList();
  }

  void filterByRegion(String region) {
    selectedRegion.value = region;
    if (region == 'All') {
      filteredCities.value = List.from(cities);
    } else {
      filteredCities.value = cities.where((t) => t.region == region).toList();
    }
  }

  void selectCity(City city) async {
    Get.toNamed(Routes.MAP, arguments: city);
  }
}
