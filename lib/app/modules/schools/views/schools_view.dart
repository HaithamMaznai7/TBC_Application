import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/schools/controllers/schools_controller.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:tbc_application/app/modules/schools/views/widgets/school_card.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/util/constants/colors.dart';

class SchoolsListView extends GetView<SchoolController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openSchoolForm(null),
        child: Icon(Icons.add),
        backgroundColor: FColors.primary,
      ),
      appBar: AppBar(
        title: Text("Schools"),
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
          // Group Filter
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text("All"),
                      selected: controller.selectedGroup.value == "All",
                      onSelected: (val) => controller.filterByGroup("All"),
                    ),
                    ...controller.schoolGroups.map((group) => ChoiceChip(
                          label: Text(group),
                          selected: controller.selectedGroup.value == group,
                          onSelected: (val) => controller.filterByGroup(group),
                        )),
                  ],
                ),
              )),

          // Schools List
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.firestore.collection(controller.collection).snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No schools found.'));
                } else {

                  final schools = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: schools.length,
                    itemBuilder: (context, index) {
                      final id = schools[index].id;
                      final data = schools[index].data();
                      final school = School.fromMap(id, data);
                      return SchoolCard(
                        school: school,
                        onView: (School school) => Get.toNamed(Routes.School_Info, arguments: school),
                        onEdit: controller.openSchoolForm,
                        onDelete: controller.deleteSchool,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
