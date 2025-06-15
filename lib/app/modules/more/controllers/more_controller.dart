import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/more/models/features.dart';
import 'package:tbc_application/app/routes/app_pages.dart';

class MoreController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var features = <Feature>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFeatures();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  void loadFeatures() async {
    var tempFeatures = [
      Feature(icon: Icons.person, title: "Users", collection: "employee", route: Routes.VIEW_USERS),
      Feature(icon: Icons.person, title: "Supervisors", collection: "supervisors", route: Routes.VIEW_SUPERVISOR),
      Feature(icon: Icons.person, title: "Contractors", collection: "contractors", route: Routes.VIEW_CONTRACTOR),
      Feature(icon: Icons.school, title: "Schools", collection: "schools", route: Routes.SCHOOL_FEATURE),
      Feature(icon: Icons.devices, title: "Assets", collection: "assets", route: Routes.VIEW_ASSETS),
      Feature(icon: Icons.devices, title: "Maintenance", collection: "maintenance_types", route: Routes.MAINTENANCE_TYPES_FEATURE),
    ];

    await Future.wait(tempFeatures.map((feature) => feature.getCount()));

    features.value = tempFeatures;
  }
}
