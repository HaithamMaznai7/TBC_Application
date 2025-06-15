import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';  // For kIsWeb
import 'package:tbc_application/app/modules/schedule/models/point.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionNotesController extends GetxController {
  var userImage = ''.obs;
  var supervisorImage = ''.obs;
  var userNote = ''.obs;
  var supervisorNote = ''.obs;
  var userRating = 0.0.obs;
  var supervisorRating = 0.0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initialize(Point point) {
    userImage.value = point.userImage ?? '';
    supervisorImage.value = point.supervisorImage ?? '';
    userNote.value = point.userNote ?? '';
    supervisorNote.value = point.supervisorNote ?? '';
    userRating.value = point.userRating ?? 0;
    supervisorRating.value = point.supervisorRating ?? 0;
  }

  Future<void> pickImage(String role) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String encodedImage;

      if (kIsWeb) {
        // Web: Read as bytes and encode
        final bytes = await pickedFile.readAsBytes();
        encodedImage = base64Encode(bytes);
      } else {
        // Mobile: Read from file and encode
        final bytes = await pickedFile.readAsBytes();
        encodedImage = base64Encode(bytes);
      }

      if (role == 'user') {
        userImage.value = encodedImage;
      } else {
        supervisorImage.value = encodedImage;
      }
    }
  }

  void removeImage(String role) {
    if (role == 'user') {
      userImage.value = '';
    } else {
      supervisorImage.value = '';
    }
  }

  Future<void> submit(Point point) async {
    point.userImage = userImage.value;
    point.supervisorImage = supervisorImage.value;
    point.userNote = userNote.value;
    point.supervisorNote = supervisorNote.value;
    point.userRating = userRating.value;
    point.supervisorRating = supervisorRating.value;

    if (point.userImage != null && point.userNote!= null && point.userImage!.isNotEmpty && point.userNote!.isNotEmpty && point.userRating!= null) {
      point.status = PointStatus.review;
    }

    if (point.supervisorImage != null && point.supervisorNote != null && point.supervisorImage!.isNotEmpty && point.supervisorNote!.isNotEmpty && point.supervisorRating!= null) {
      point.status = PointStatus.completed;
    }

    await _firestore.collection('inspection_points').doc(point.id).set(point.toJson());
    Get.back(result: point);
  }
}
