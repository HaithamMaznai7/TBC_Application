import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/controllers/schedule_controller.dart';
import 'package:tbc_application/app/modules/schedule/models/point.dart';
import 'package:tbc_application/app/modules/schedule/views/visits/point_card.dart';
import 'package:tbc_application/app/modules/schedule/views/widgets/schedule_header.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/device/device_utility.dart';
import 'package:tbc_application/util/formatters/formatter.dart';

class MaintenancesDetails extends GetView<ScheduleController> {
  const MaintenancesDetails({super.key,required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FColors.white,
      appBar: AppBar(
        backgroundColor: FColors.white,
        title: Text('School Name'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.report, color: FColors.primary),
            onPressed: () {
              int selected = 0;
              Get.bottomSheet(
                Material(
                  color: FColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(FSizes.cardRadiusMd),
                    topRight: Radius.circular(FSizes.cardRadiusMd),
                  ),
                  child: Container(
                    height: FDeviceUtils.getScreenHeight() * .6,  // Set a proper height
                    width: FDeviceUtils.getScreenWidth(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(FSizes.cardRadiusMd),
                      color: FColors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_drop_down, color: FColors.primary),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ChoiceChip(
                                label: Text('school details'),
                                selected: selected == 0,
                                onSelected: (value) {
                                  selected = 0;
                                  controller.update();
                                },
                              ),
                              const SizedBox(width: 10),
                              ChoiceChip(
                                label: Text('Supervisor info'),
                                selected: selected == 1,
                                onSelected: (value) {
                                  selected = 1;
                                  controller.update();
                                },
                              ),
                              const SizedBox(width: 10),
                              ChoiceChip(
                                label: Text('contractor info'),
                                selected: selected == 2,
                                onSelected: (value) {
                                  selected = 2;
                                  controller.update();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: 
                            selected == 0
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      'Name: School Name',
                                      style: TextStyle(color: FColors.primary),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Ministerial No: 345466',
                                      style: TextStyle(color: FColors.primary),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Ministerial office: مكاتب وزارة التربية',
                                      style: TextStyle(color: FColors.primary),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Group No: P3',
                                      style: TextStyle(color: FColors.primary),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Visit Date: ${EFormatter.getDateFormat.format(DateTime.now())}',
                                      style: TextStyle(color: FColors.primary),
                                    ),
                                  ],
                              )
                              : selected == 1
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    'Supervisor Name: Haitham Maznai',
                                    style: TextStyle(color: FColors.primary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Status: In Progress',
                                    style: TextStyle(color: FColors.primary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Progress percentage: 10%',
                                    style: TextStyle(color: FColors.primary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Notes: No notes',
                                    style: TextStyle(color: FColors.primary),
                                  ),
                                ],
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    'Contractor Name: شركة بن لادن',
                                    style: TextStyle(color: FColors.primary),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Contractor Category: Cleaning and renovation',
                                    style: TextStyle(color: FColors.primary),
                                  ),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isScrollControlled: true,  // Allow the sheet to take more space
              );
            },
          ),

        ],
      ),
      body: PointsView(),
    );
  }
}

class PointsView extends GetView<ScheduleController> {
  const PointsView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Point> list = List.generate(20, (index) => Point(id: '${index + 1}', title: 'title', description: 'description', status: PointStatus.none));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FSizes.md,
        vertical: FSizes.lg,
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: Point().snapshot,
        builder: (builderContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            // Map Firestore data to a list of Rx<Point> objects
            var points = snapshot.data!.docs.map((doc) {
              Point point = Point().fromCollection(doc.id, doc.data());
              return Rx<Point>(point);
            }).toList();

            return ListView.builder(
              shrinkWrap: true,
              itemCount: points.length,
              itemBuilder: (context, index) {
                return Obx(() => PointCard(point: points[index].value));
              },
            );
          }

          return const Center(child: Text('No data available'));
        },
      )
    );
  }
}

class MaintenancesDetailsHeader extends GetView<ScheduleController> {
  const MaintenancesDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FColors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // margin: margin,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: FColors.secondaryExtraSoft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text(
              EFormatter.getDateFormat.format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic
              ),
            ),
            const SizedBox(width: 8),
            Text(
              EFormatter.getDateFormat.format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic
              ),
            ),
        
            // SizedBox(width: 16),
            // ElevatedButton(
            //   onPressed: () => controller.openEventDialog(),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: FColors.primary,
            //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(Icons.add, color: Colors.white),
            //       const SizedBox(width: 8),
            //       Text('Add Event', style: TextStyle(color: Colors.white)),
            //     ],
            //   ),
            // )
          ],
        )
      ),
    );
  }
}