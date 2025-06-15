import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tbc_application/app/modules/map/controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.initialPosition,
              zoom: 14.0,
            ),
            markers: Set<Marker>.of(controller.markers.values),
            onTap: (_) => controller.clearSelection(),
          )),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => controller.goToCurrentLocation(),
                  ),
                  Text('Select a School'),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.selectedLatLng.value != null &&
                controller.selectedSchool.value != null) {
              return Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${controller.selectedSchool.value!.name}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('${controller.selectedSchool.value!.name}'),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => controller.openSchool(controller.selectedSchool.value!),
                          child: Text('Show Details'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }
}
