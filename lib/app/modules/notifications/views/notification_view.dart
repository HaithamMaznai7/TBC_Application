import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/controllers/page_index_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_bottom_navigation_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:tbc_application/app/modules/notifications/controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  final pageIndexController = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      // appBar: AppBar(
      //   title: Text(
      //     'Notifications',
      //     style: TextStyle(
      //       color: FColors.primary,
      //       fontSize: 16,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   leading: IconButton(
      //     onPressed: () => Get.back(),
      //     icon: Icon(Iconsax.arrow_right_3),
      //   ),
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   bottom: PreferredSize(
      //     preferredSize: Size.fromHeight(1),
      //     child: Container(
      //       width: MediaQuery.of(context).size.width,
      //       height: 1,
      //       color: FColors.secondaryExtraSoft,
      //     ),
      //   ),
      // ),
      widget: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamNotifications(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              List<QueryDocumentSnapshot<Map<String, dynamic>>> notifications = snapshot.data!.docs;
              return ListView.builder(
                itemCount: notifications.length,
                // itemExtent: 8,
                itemBuilder: (context, index) {
                  var notification = notifications[index].data();
                  DateTime notificationTime = (notification['createdAt'] as Timestamp).toDate();
                  String timeAgo = timeago.format(notificationTime);

                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    color: notification['isRead'] as bool ? FColors.white : const Color.fromARGB(255, 225, 248, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: ListTile(
                    title: Text(notification['message'] ?? 'No message'),
                    subtitle: Text(timeAgo),
                    subtitleTextStyle: TextStyle(
                      color: FColors.secondary,
                      fontSize: 12,
                      decorationThickness: .3
                    ),
                    titleAlignment: ListTileTitleAlignment.center,
                    trailing: Icon(Icons.home, size: 16),
                    onTap: controller.onClick(notification['data']),
                  )
                  );
                },
              );
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}