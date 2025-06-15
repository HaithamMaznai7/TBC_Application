import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/controllers/schedule_controller.dart';
import 'package:tbc_application/app/modules/schedule/views/maintenance/maintenance_details.dart';
import 'package:tbc_application/util/constants/sizes.dart';

class MaintenancesView extends GetView<ScheduleController> {
  const MaintenancesView({super.key});

  @override
  Widget build(BuildContext context) {
    List<int> list = List.generate(20, (index) => index + 1);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FSizes.md,
        vertical: FSizes.lg,
      ),
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true, // Makes ListView height based on content
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            child: Card(
              child: ListTile(
                title: Text('School ${list[index]}'),
                subtitle: Text('visits in school ${list[index]}'),
              ),
            ),
            onTap: () {
              // Navigate to MaintenanceDetailsView\
              Get.to(MaintenancesDetails(index: index));
            },
            
          );
        },
      ),
    );
  }
}
