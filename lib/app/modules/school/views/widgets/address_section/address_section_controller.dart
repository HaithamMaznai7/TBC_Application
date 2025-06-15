import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:tbc_application/app/modules/schools/controllers/schools_controller.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class AddressSectionController extends GetxController {
  Rx<Address?> address = Rx<Address?>(null);
  Rx<LatLng> location = Rx<LatLng>(LatLng(0, 0));
  Rx<Map<MarkerId, Marker>> mark = Rx<Map<MarkerId, Marker>>({});
  late SchoolController controller ;

  AddressSectionController(Address? initialAddress,this.controller) {
    if (initialAddress != null) {
      address.value = initialAddress;
      if (initialAddress.latitude != null && initialAddress.longitude != null) {
        location.value = LatLng(initialAddress.latitude!, initialAddress.longitude!);
        _setMarker();
      }
    }
  }

  void _setMarker() {
    MarkerId markerId = MarkerId("school_location");
    Marker marker = Marker(
      markerId: markerId,
      position: location.value,
      infoWindow: InfoWindow(
        title: "School Location",
        snippet: "This is the location of the school",
      ),
    );
    mark.value = {markerId: marker};
  }

  goToLocation() {
    try {
      MapsLauncher.launchCoordinates(
        location.value.latitude,
        location.value.longitude,
      );
    } catch (e) {
      CustomToast.errorToast('Error', 'Error : ${e}');
    }
  }

  void clearAddress() {
    address.value = null;
    location.value = LatLng(0, 0);
    mark.value.clear();
  }

  void openAddress() {
    Get.toNamed(Routes.ADD_EDIT_ADDRESS, arguments: address.value ?? Address(latitude: 24.7136, longitude: 46.6753))?.then((result) async {
      if (result != null && result is Address) {

        address.value = result;
        if (result.latitude != null && result.longitude != null) {
          location.value = LatLng(result.latitude!, result.longitude!);
          _setMarker();
        }
        // address.value = await address.value!.save();
        controller.address.value = address.value;
      }
    });
  }
}
