import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/modules/schools/models/city.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:tbc_application/app/routes/app_pages.dart';

class MapController extends GetxController {
  var selectedCity = City().obs;

  RxMap<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  final Rx<LatLng?> selectedLatLng = Rx<LatLng?>(null);
  final Rx<School?> selectedSchool = Rx<School?>(null);

  LatLng initialPosition = LatLng(24.7136, 46.6753); // مثال: الرياض

  @override
  void onInit() {

    selectedCity.value = Get.arguments as City;
    initialPosition = LatLng(selectedCity.value.lat, selectedCity.value.lng);
    
    loadSchools();

    super.onInit();
  }

Future<void> loadSchools() async {
  List<School> schools = await School().get();

  for (final school in schools) {


    if (school.addressID != null) {
      final address = await school.address();

      if (address != null && address.latitude != null && address.longitude != null) {
        final position = LatLng(address.latitude!, address.longitude!);
        final markerId = MarkerId(school.id!);
        final marker = Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(
            title: school.name,
            snippet: school.ministerialID,
          ),
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onTap: () {
            selectedSchool.value = school;
            selectedLatLng.value = position;
          },
        );
        markers[markerId] = marker;
      }
    }
  }
}


  void clearSelection() {
    selectedSchool.value = null;
    selectedLatLng.value = null;
  }

  void openSchool(School school) {
    clearSelection();
    Get.toNamed(Routes.School_Info, arguments: school);
  }

  void goToCurrentLocation() {
    Get.back();
  }
}
