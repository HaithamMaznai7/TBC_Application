import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/assets/controllers/assets_controller.dart';
import 'package:tbc_application/app/modules/maintenence_types/models/maintenance_type_model.dart';
import 'package:tbc_application/app/modules/school/views/widgets/base_section.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';

class AddEditAssetView extends StatelessWidget {
  final AssetsController controller = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.asset.value?.id == null ? "Add Asset" : "Edit Asset"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            Obx(() => DropdownButtonFormField<WorkScop>(
              value: controller.selectedType.value,
              items: WorkScop.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.name.capitalizeFirst ?? level.toString().split('.').last),
                );
              }).toList(),
              onChanged: (WorkScop? value) {
                if (value != null) {
                  controller.selectedType.value = value;
                }
              },
              decoration: const InputDecoration(labelText: "School Level"),
            )),

            SizedBox(height: 10),
            Obx(() {
              List<MaintenanceType> types = controller.maintenances;

              return BaseSectionCard(
                title: "الغيارات و الصيانة",
                actions: [
                  IconButton(onPressed: controller.addMaintenances, icon: Icon(Icons.add))
                ],
                body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                      spacing: 9,
                      children: types.map((s) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${s.name}'),
                          Text('${s.service}'),
                        ]
                    )).toList(),
                        
                  ),
                ),
              );
            }) ,
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.saveAsset,
              child: Text(controller.asset.value?.id == null ? "Create" : "Update"),
            )
          ],
        ),
      ),
    );
  }
}