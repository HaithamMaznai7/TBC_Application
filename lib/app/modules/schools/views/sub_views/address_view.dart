import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tbc_application/app/modules/schools/controllers/address_controller.dart';
import 'package:tbc_application/app/modules/schools/models/city.dart';
import 'package:tbc_application/app/widgets/custom_input.dart';
import 'package:tbc_application/company_data.dart';
import 'package:tbc_application/util/validators/validation.dart';

class AddressView extends GetView<AddressController> {
  final AddressController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إضافة عنوان")),
      body: Obx(() => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            controller.cities.length >= 1 
              ? DropdownButtonFormField<String>(
                value: controller.address.value.cityID,
                hint: Text("اختر المدينة"),
                items: controller.cities.map((City city) =>
                  DropdownMenuItem<String>(value: city.name!, child: Text('${city.name}'))
                ).toList(),
                onChanged: (value) => controller.address.update((val) => val?.cityID = value),
              )
              : SizedBox(),
            
            CustomInput(
              controller: controller.streetC,
              label: "الشارع",
              hint: "الشارع",
              onSaved: (String? val) => controller.streetC.text = val ?? '',
              validator: FValidation.validateEmail,
            ),
            CustomInput(
              controller: controller.address1C,
              label: "Address 1",
              hint: "Address Line 1 (اختياري)",
              onSaved: (String? val) => controller.streetC.text = val ?? '',
              validator: FValidation.validateEmail,
            ),
            CustomInput(
              controller: controller.address2C,
              label: "Address 2",
              hint: "Address Line 2 (اختياري)",
              onSaved: (String? val) => controller.streetC.text = val ?? '',
              validator: FValidation.validateEmail,
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(controller.address.value.latitude ?? CompanyData.office['latitude'], controller.address.value.longitude ?? CompanyData.office['longitude']),
                  zoom: 14,
                ),
                onMapCreated: controller.setMapController,
                onTap: controller.updateLocation,
                markers: {
                  Marker(
                    markerId: MarkerId("current"),
                    position: LatLng(controller.address.value.latitude ?? CompanyData.office['latitude'], controller.address.value.longitude ?? CompanyData.office['longitude']),
                    draggable: true,
                    onDragEnd: controller.updateLocation,
                  )
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.saveAddress,
              child: Text("Save"),
            ),
          ],
        ),
      )),
    );
  }
}
