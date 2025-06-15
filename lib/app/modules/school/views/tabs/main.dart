import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/school/controllers/school_controller.dart';
import 'package:tbc_application/app/modules/school/views/widgets/assets_section.dart';
import 'package:tbc_application/app/modules/school/views/widgets/base_section.dart';
import 'package:tbc_application/app/modules/school/views/widgets/supervisor_section/supervisors_section.dart';

class MainTab extends GetView<SchoolDetailsController> {
  const MainTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
            BaseSectionCard(
              title: "الاصول",
              actions: [
                IconButton(onPressed: controller.addAssets, icon: Icon(Icons.add))
              ],
              body: AssetsSectionBody(controller),
            ),

            
            SizedBox(height: 16.0),
            
            SizedBox(height: 16.0),

            SupervisorsSectionBody(controller),

            SizedBox(height: 16.0),
      ],
    );
  }



}