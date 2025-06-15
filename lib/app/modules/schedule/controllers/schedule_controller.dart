import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schools/models/city.dart';
import 'package:tbc_application/app/routes/app_pages.dart';

class ScheduleController extends GetxController with GetTickerProviderStateMixin {

  late TabController pageController ;

  RxInt pageIndex = 0.obs;
  RxBool detailsView = false.obs;

  var cities = <City>[].obs;
  var filteredCities = <City>[].obs;
  var regions = <String>[].obs;
  var selectedRegion = 'All'.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    
    pageController = TabController(length: 2, vsync: this, initialIndex: 1);

    loadCities();

    super.onInit();
  }


  void loadCities() async {
    cities.value = await City.all();
    updateRegion(cities);
    filterByRegion('All');
  }

  void openEventDialog() async {
    print('openEventDialog');
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

  void changeTab(int index) async {
    pageIndex.value = index;
    switch (index) {
      case 1:
        Get.offAllNamed(Routes.HOME);
        break;
      case 2:
        Get.offAllNamed(Routes.SCHEDULE);
        break;
    }
  }
}
