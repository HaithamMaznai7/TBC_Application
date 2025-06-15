import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tbc_application/app/modules/school/views/widgets/address_section/address_section_controller.dart';
import 'package:tbc_application/app/modules/school/views/widgets/base_section.dart';
import 'package:tbc_application/app/modules/schools/controllers/schools_controller.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';

class AddressSectionBody extends StatelessWidget {
  final Address? address;
  final SchoolController schoolController;

  const AddressSectionBody({super.key, required this.address, required this.schoolController});

  @override
  Widget build(BuildContext context) {
    // Inject controller with address (only once)
    final controller = Get.put(AddressSectionController(address,schoolController), tag: address?.id.toString());

    return Obx(() => BaseSectionCard(
      title: "الموقع",
      actions: [
        IconButton(
          icon: Icon(controller.address.value != null ? Icons.edit : Icons.add, color: Colors.white),
          onPressed: controller.openAddress,
        ),
        SizedBox(width: 5),
        if(controller.address.value != null)
        IconButton(
          icon: Icon(Icons.directions, color: Colors.white),
          onPressed: controller.goToLocation,
        ),
      ],
      flow: true,
      body: controller.address.value != null
          ? Container(
              width: double.infinity,
              height: 220,
              padding: EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.location.value,
                    zoom: 14.0,
                  ),
                  zoomControlsEnabled: false,
                  myLocationEnabled: false,
                  compassEnabled: false,
                  markers: Set<Marker>.of(controller.mark.value.values),
                ),
              ),
            )
          : SizedBox()
          ),
    );
  }
}
