import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/modules/schools/models/city.dart';

class AddressController extends GetxController {
  var address = Address(latitude: 24.7136, longitude: 46.6753).obs; // default: Riyadh
  late GoogleMapController mapController;

  var cities = <City>[].obs;
  TextEditingController streetC = TextEditingController();
  TextEditingController address1C = TextEditingController();
  TextEditingController address2C = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    address.value = Get.arguments as Address;
    streetC.text = address.value.street ?? '';
    address1C.text = address.value.addressLine1 ?? '';
    address2C.text = address.value.addressLine2 ?? '';
    address.value.cityID = address.value.cityID;

    loadCities();

    super.onInit();
  }

  loadCities() async {
    cities.value = await City.all();
    update();
  }

  void updateLocation(LatLng latLng) {
    address.update((val) {
      val?.latitude = latLng.latitude;
      val?.longitude = latLng.longitude;
    });
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void saveAddress() {
    address.value.street = streetC.text;
    address.value.addressLine2 = address2C.text;
    address.value.addressLine1 = address1C.text;
    address.value.region = cities.where((city) => city.name == address.value.cityID).first.region;
    Get.back<Address>(result: address.value);
  }
}
