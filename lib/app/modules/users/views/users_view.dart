import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/uesrs/models/user.dart';
import 'package:tbc_application/app/modules/users/controllers/users_controller.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/modules/users/views/user_card.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/sizes.dart';

class UsersView extends GetView<UsersController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("users"),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: controller.importFromExcel,
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: controller.exportToExcel,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(FSizes.spaceBtwItems),
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text("All", style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: controller.selectedRole.value == null ? FColors.white : FColors.primary,
                    ),),
                    selected: controller.selectedRole.value == null,
                    onSelected: (val) => controller.changeSelectedRole(null),
                    showCheckmark: false,
                    selectedColor: FColors.primary.withOpacity(0.7),
                  ),
                  ...UserRole.values.map((role) => ChoiceChip(
                        label: Text(role.label, style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: controller.selectedRole.value == role ? FColors.white : FColors.primary,
                        ),),
                        selected: controller.selectedRole.value == role,
                        onSelected: (val) => controller.changeSelectedRole(role),
                        showCheckmark: false,
                        selectedColor: FColors.primary.withOpacity(0.7),
                      )),
                ],
              ),
            ))
          ),
          SizedBox(height: FSizes.spaceBtwItems),
          // Contractors List
          Expanded(
            child: Obx(() => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.selectedRole.value == null 
              ? controller.firestore.collection(controller.collection).snapshots()
              : controller.firestore.collection(controller.collection).where('role', isEqualTo: controller.selectedRole.value!.value).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found.'));
                } else {
                  final users = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      Employee user = Employee.fromMap(users[index].id ,users[index].data()); // Set the document ID to the user object
                      return UserCard(
                        user: user,
                        onEdit: (user) => controller.openUserForm(user),
                        onDelete: (user) => controller.deleteUser(user),
                      );
                    },
                  );
                }
              },
            )
          ),),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openUserForm(null),
        backgroundColor: FColors.primary,
        child: Icon(Icons.add, color: FColors.white),
      ),
    );
  }
}