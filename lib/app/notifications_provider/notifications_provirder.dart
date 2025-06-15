import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationProvider {
  static Future<String?> getToken() async {
    try {
      if (kIsWeb) {
        // Make sure to add your VAPID key
        // return await FirebaseMessaging.instance.getToken(
        //   vapidKey: "1:640398608610:web:cbc5300d3ba684fda776bb",
        // );
        return null;
      } else {
        return await FirebaseMessaging.instance.getToken();
      }
    } catch (e) {
      print('🚫 Error fetching FCM token: $e');
      return null;
    }
  }
}

