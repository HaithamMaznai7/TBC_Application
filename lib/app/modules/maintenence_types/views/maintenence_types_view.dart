import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/maintenence_types/controllers/maintenance_type_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';

class MaintenanceTypesView extends GetView<MaintenanceTypeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maintenance Types"),
        actions: [
          Obx(() => controller.isImporting.value
            ? CircularProgressIndicator( 
                color: FColors.primary,
                strokeWidth: 2,
              )
            :  IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: controller.importFromExcel,
            ),
          ),
          Obx(() => controller.isExporting.value
            ? CircularProgressIndicator( 
                color: FColors.primary,
                strokeWidth: 2,
              )
            :  IconButton(
              icon: Icon(Icons.download),
              onPressed: controller.exportToExcel,
            )
          ),
        ],
      ),
      body: Column(
        children: [
          // Services Slider
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text("All"),
                    selected: controller.selectedService.value == "All",
                    onSelected: (val) => controller.filterByService("All"),
                  ),
                  ...controller.services.map((service) => ChoiceChip(
                        label: Text(service),
                        selected: controller.selectedService.value == service,
                        onSelected: (val) => controller.filterByService(service),
                      )),
                ],
              ),
            )
          ),

          // Maintenance Types List
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.filteredMaintenanceTypes.length,
                  itemBuilder: (context, index) {
                    final type = controller.filteredMaintenanceTypes[index];
                    return Card(
                      child: ListTile(
                        title: Text('${type.name}'),
                        subtitle: Text("${type.service} - ${type.frequency} ${type.unit}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => controller.editMaintenanceType(type),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => controller.deleteMaintenanceType(type),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addMaintenanceType,
        child: Icon(Icons.add),
        backgroundColor: FColors.primary,
      ),
    );
  }
}
