import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_application/app/controllers/page_index_controller.dart';
import 'package:tbc_application/app/controllers/presence_controller.dart';
import 'package:tbc_application/app/notifications_provider/notifications_provirder.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tbc_application/util/localization/localization.dart';
import 'package:tbc_application/util/theme/theme.dart';
import 'package:universal_html/html.dart' as html;

void main() async{

  
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyC2HiU1gV0sfwPs0wYByVBeH8BnB9_hqDw",
        authDomain: "tbc-app-aea0c.firebaseapp.com",
        projectId: "tbc-app-aea0c",
        storageBucket: "tbc-app-aea0c.firebasestorage.app",
        messagingSenderId: "640398608610",
        appId: "1:640398608610:web:cbc5300d3ba684fda776bb"
      ),
    );
  }else{
    await Firebase.initializeApp();
  }
  FirebaseMessaging.instance.setAutoInitEnabled(true);

  await requestNotificationPermission();

  String? token = await NotificationProvider.getToken();
  print('Firebase Messaging token: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📬 Foreground message received: ${message.notification?.title}');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(PresenceController(), permanent: true);
  Get.put(PageIndexController(), permanent: true);

  String initialRoute = await _getInitialScreen();
  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue
                ),
              ),
            ),
          );
        }
        return GetMaterialApp(
          translations: FLocalization(), // your translations
          locale: Get.deviceLocale, // translations will be displayed in that locale
          fallbackLocale: const Locale('en'),
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: FAppTheme.lightTheme,
          darkTheme: FAppTheme.darkTheme,
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  print("🔕 Background message: ${message.messageId}");
  // Handle background message here
}

Future<void> requestNotificationPermission() async {
  try {
    final settings = await FirebaseMessaging.instance
        .requestPermission()
        .timeout(const Duration(seconds: 5));

    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        print('✅ User granted permission');
        break;
      case AuthorizationStatus.denied:
        print('❌ User denied permission');
        break;
      case AuthorizationStatus.notDetermined:
        print('❓ Permission not determined');
        break;
      case AuthorizationStatus.provisional:
        print('⚠️ Provisional permission granted');
        break;
    }
  } catch (e) {
    print('🚫 Notification permission error or timeout: $e');
    // Still allow app to load
  }
}

Future<String> _getInitialScreen() async {
  final prefs = await SharedPreferences.getInstance();
  final remember = prefs.getBool('remember') ?? false;

  if (remember) {
    if (kIsWeb) {
      final cookie = html.document.cookie;
      final hasToken = cookie != null && cookie.contains('idToken=');
      return hasToken ? Routes.HOME : Routes.LOGIN;
    } else {
      final user = FirebaseAuth.instance.currentUser;
      return user != null ? Routes.HOME : Routes.LOGIN;
    }
  }
  return Routes.LOGIN;
}
