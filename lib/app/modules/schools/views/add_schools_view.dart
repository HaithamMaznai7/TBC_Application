import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/school/views/widgets/address_section/address_section_body.dart';
import 'package:tbc_application/app/modules/schools/controllers/schools_controller.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/widgets/custom_input.dart';
import '../models/school_model.dart';

class AddEditSchoolView extends StatelessWidget {
  final SchoolController controller = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.school == null ? "Add School" : "Edit School"),
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
              controller: controller.ministerialIDController,
              decoration: InputDecoration(labelText: "Ministerial ID"),
            ),
            TextField(
              controller: controller.groupNameController,
              decoration: InputDecoration(labelText: "Group Name"),
            ),
            SizedBox(height: 10),
            Obx(() => DropdownButtonFormField(
                  value: controller.selectedLevel.value,
                  items: SchoolLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) => controller.selectedLevel.value = value ?? SchoolLevel.primary,
                  decoration: InputDecoration(labelText: "School Level"),
                )),
                Obx(() => DropdownButtonFormField(
                  value: controller.selectedType.value,
                  items: SchoolType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (value) => controller.selectedType.value = value ?? SchoolType.male,
                  decoration: InputDecoration(labelText: "School Type"),
                )),
            SizedBox(height: 10),
            Obx(() => AddressSectionBody(
              address: controller.address.value,
              schoolController: controller,
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.saveSchool,
              child: Text(controller.school == null ? "Create" : "Update"),
            )
          ],
        ),
      ),
    );
  }
}