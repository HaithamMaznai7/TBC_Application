import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/contractors/controllers/contractors_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';

class ContractorsView extends GetView<ContractorsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contractors"),
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
                  itemCount: controller.contractors.length,
                  itemBuilder: (context, index) {
                    final item = controller.contractors[index];
                    return Card(
                      child: ListTile(
                        title: Text('${item.employee.fullname}'),
                        subtitle: Text("${item.employeeId}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => controller.openContractorForm(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => controller.deleteContractor(item),
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
        onPressed: () => controller.openContractorForm(null),
        child: Icon(Icons.add),
        backgroundColor: FColors.primary,
      ),
    );
  }
}