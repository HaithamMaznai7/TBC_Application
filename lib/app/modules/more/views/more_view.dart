import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/more/controllers/more_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_bottom_navigation_bar.dart';

class MoreView extends GetView<MoreController> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      widget: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade100,
                ),
                child: Obx(() {
                  if (controller.features.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: controller.features.map((feature) {
                      return Card(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => Get.toNamed(feature.route),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                feature.icon,
                                size: 70,
                                color: FColors.primary,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() => Text(
                                        feature.count.value,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: FColors.secondaryDark,
                                        ),
                                      )),
                                  Text(
                                    feature.title,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: FColors.grey,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
