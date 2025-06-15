import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/views/visits/note_dialog_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/modules/schedule/models/point.dart';

class InspectionNotesView extends GetView<InspectionNotesController> {
  final Point point;
  final String role;
  final String cancelTitle;

  InspectionNotesView({
    Key? key,
    required this.point,
    required this.role,
    this.cancelTitle = 'delete',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the point data inside the build method
    controller.initialize(point);

    return Scaffold(
      backgroundColor: FColors.light,
      appBar: AppBar(
        title: Text(role == 'user' ? 'Add Note'.tr : 'Review Note'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImageSection('User Image', 'user', controller.userImage),
              _buildNoteField('User Note', controller.userNote),
              _buildRatingBar('User Rating', controller.userRating),
              if (role == 'supervisor') ...[
                const Divider(),
                _buildImageSection('Supervisor Image', 'supervisor', controller.supervisorImage),
                _buildNoteField('Supervisor Note', controller.supervisorNote),
                _buildRatingBar('Supervisor Rating', controller.supervisorRating),
              ],
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(String label, String role, RxString image) {
    return Obx(() => Column(
      children: [
        Text(label),
        GestureDetector(
          onTap: () => controller.pickImage(role),
          child: image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
                    base64Decode(image.value),
                    key: UniqueKey(),  // Force widget rebuild
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
        ),
        if (image.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => controller.removeImage(role),
          ),
      ],
    ));
  }

  Widget _buildNoteField(String label, RxString note) {
    return Obx(() => TextField(
          onChanged: (value) => note.value = value,
          controller: TextEditingController(text: note.value),
          decoration: InputDecoration(labelText: label),
        ));
  }

  Widget _buildRatingBar(String label, RxDouble rating) {
    return Obx(() => Column(
          children: [
            Text(label),
            Slider(
              value: rating.value,
              min: 0,
              max: 10,
              divisions: 10,
              label: rating.value.toString(),
              onChanged: (value) => rating.value = value,
            ),
          ],
        ));
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => controller.submit(point),
          child: Text('Submit'.tr),
        ),
        OutlinedButton(
          onPressed: () => Get.back(),
          child: Text(cancelTitle),
        ),
      ],
    );
  }
}
