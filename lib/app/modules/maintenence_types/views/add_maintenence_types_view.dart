import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/maintenance_type_controller.dart';
import '../models/maintenance_type_model.dart';

class AddEditMaintenanceTypeView extends StatelessWidget {
  final MaintenanceTypeController controller = Get.find();
  final String? maintenanceTypeId = (Get.arguments as MaintenanceType).id;

  @override
  Widget build(BuildContext context) {
    if (maintenanceTypeId != null) {
      controller.loadMaintenanceTypeData(maintenanceTypeId!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.type == null ? "Add Maintenance Type" : "Edit Maintenance Type"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: controller.serviceController,
              decoration: InputDecoration(labelText: "Service"),
            ),
            DropdownButtonFormField<String>(
              value: controller.unitController.text.isNotEmpty ? controller.unitController.text : 'Daily',
              onChanged: (value) {
                controller.unitController.text = value ?? '';
              },
              items: ["Daily", "Weekly", "Monthly", "Yearly"].map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              decoration: InputDecoration(labelText: "Unit"),
            ),
            TextField(
              controller: controller.frequencyController,
              decoration: InputDecoration(labelText: "Frequency"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.addNewMaintenanceType();
              },
              child: Text(maintenanceTypeId == null ? "Add" : "Update"),
            )
          ],
        ),
      ),
    );
  }
}
