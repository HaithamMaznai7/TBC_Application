import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/assets/controllers/assets_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';

class AssetsView extends GetView<AssetsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openAssetsForm(null),
        child: Icon(Icons.add),
        backgroundColor: FColors.primary,
      ),
      appBar: AppBar(
        title: Text("Assets"),
        actions: [
          //   Obx(() => controller.isImporting.value
          //   ? CircularProgressIndicator( 
          //       color: FColors.primary,
          //       strokeWidth: 2,
          //     )
          //   :  IconButton(
          //     icon: Icon(Icons.upload_file),
          //     onPressed: controller.importFromExcel,
          //   ),
          // ),
          // Obx(() => controller.isExporting.value
          //   ? CircularProgressIndicator( 
          //       color: FColors.primary,
          //       strokeWidth: 2,
          //     )
          //   :  IconButton(
          //     icon: Icon(Icons.download),
          //     onPressed: controller.exportToExcel,
          //   )
          // ),
        ],
      ),
      body: Column(
        children: [

          // Group Filter
          // Obx(() => SingleChildScrollView(
          //       scrollDirection: Axis.horizontal,
          //       child: Row(
          //         children: [
          //           ChoiceChip(
          //             label: Text("All"),
          //             selected: controller.selectedGroup.value == "All",
          //             onSelected: (val) => controller.filterByGroup("All"),
          //           ),
          //           ...controller.schoolGroups.map((group) => ChoiceChip(
          //                 label: Text(group),
          //                 selected: controller.selectedGroup.value == group,
          //                 onSelected: (val) => controller.filterByGroup(group),
          //               )),
          //         ],
          //       ),
          //     )),

          // Schools List
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: controller.assets.length,
                  itemBuilder: (context, index) {
                    final asset = controller.assets.elementAt(index);
                    return Card(
                      child: ListTile(
                        title: Text('${asset.name}'),
                        subtitle: Text("Type: ${asset.type.label}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => controller.openAssetsForm(asset),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => controller.deleteAsset(asset),
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
    );
  }
}
