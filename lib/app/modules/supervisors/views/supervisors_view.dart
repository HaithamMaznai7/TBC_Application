import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/supervisors/controllers/supervisors_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';

class SupervisorsView extends GetView<SupervisorsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supervisors"),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.upload_file),
          //   onPressed: controller.importFromExcel,
          // ),
          // IconButton(
          //   icon: Icon(Icons.download),
          //   onPressed: controller.exportToExcel,
          // ),
        ],
      ),
      body: Column(
        children: [
            // Contractors List
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.supervisors.length,
                  itemBuilder: (context, index) {
                    final item = controller.supervisors[index];
                    return Card(
                      child: ListTile(
                        title: Text('${item.employee.fullname}'),
                        subtitle: Text("${item.employeeId}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => controller.openSupervisorForm(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => controller.deleteSupervisor(item),
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
        onPressed: () => controller.openSupervisorForm(null),
        child: Icon(Icons.add),
        backgroundColor: FColors.primary,
      ),
    );
  }
}