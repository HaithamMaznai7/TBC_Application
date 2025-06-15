import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/school/controllers/school_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';

class AssetsSectionBody extends StatelessWidget {

  final SchoolDetailsController controller;

  const AssetsSectionBody(this.controller, {super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(()=> Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        spacing: 9,
        children: controller.assets.map((s) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${s.name}'),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: FColors.primary),
                  onPressed: () => controller.add(s),
                ),
                Text('${controller.num}'),
                IconButton(
                  icon: Icon(Icons.remove, color: FColors.secondary),
                  onPressed: () => controller.remove(s),
                ),
              ],
            ),
          ]
        )).toList(),
      ),
    ));
  }
}
