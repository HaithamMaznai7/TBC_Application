import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:tbc_application/app/modules/schools/models/school_model.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/util/constants/colors.dart';

class NotificationController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamNotifications() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("notifications").where('user_id', isEqualTo: uid).snapshots();
  }

Callback? onClick(Map<String, dynamic>? notification) {
  if (notification != null) {
    return () async {
      try {
        // Check the notification type
        if (notification['type'] == 'School') {
          School? school ;
          school = await School().find(notification['id']);

          // Safely check if the school object is not null
          if (school != null) {
            Get.toNamed(
              Routes.School_Info,
              arguments: school,
            );
          } else {
            // Handle the null case gracefully
            Get.snackbar(
              'Error',
              'School not found',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: FColors.error,
              colorText: FColors.white,
            );
            print('Error: School object is null');
          }
        } else {
          print('Unknown notification type: ${notification['type']}');
        }
      } catch (e) {
        print('Error while handling notification: $e');
        Get.snackbar(
          'Error',
          'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: FColors.error,
          colorText: FColors.white,
        );
      }
    };
  }

  return null;
}

}
