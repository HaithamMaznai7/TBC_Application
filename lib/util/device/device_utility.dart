import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:package_info/package_info.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class FDeviceUtils {

  static void hideKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  static Future<void> setStatusBarColor(Color color) async {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: color)
    );
  }

  static bool isLandscapeOrientation(BuildContext context) {
    final viewInsets = View
        .of(context)
        .viewInsets;
    return viewInsets.bottom == 0;
  }

  static bool isPortraitOrientation(BuildContext context) {
    final viewInsets = View
        .of(context)
        .viewInsets;
    return viewInsets.bottom != 0;
  }

  static void setFullScreen(bool enable) {
    SystemChrome.setEnabledSystemUIMode(
        enable ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge);
  }

  static double getScreenHeight({BuildContext? context}) {
    return context == null
      ? MediaQuery.of(Get.context!).size.height
      : MediaQuery.of(context).size.height ;
  }

  static double getScreenWidth({BuildContext? context}) {
    return context == null
        ? MediaQuery.of(Get.context!).size.width
        : MediaQuery.of(context).size.width ;
  }

  static double getPixelRatio({BuildContext? context}) {
    return context == null
        ? MediaQuery.of(Get.context!).devicePixelRatio
        : MediaQuery.of(context).devicePixelRatio ;
  }

  static double getStatusBarHeight({BuildContext? context}) {
    return context == null
        ? MediaQuery.of(Get.context!).padding.top
        : MediaQuery.of(context).padding.top ;
  }

  static double getBottomNavigationBarHeight() {
    return kBottomNavigationBarHeight ;
  }

  static double getAppBarHeight() {
    return kToolbarHeight ;
  }

  static double getKeyboardHeight() {
    final viewInsets = MediaQuery.of(Get.context!).viewInsets ;
    return viewInsets.bottom;
  }

  static Future<bool> isKeyboardVisible() async {
    final viewInsets = View.of(Get.context!).viewInsets ;
    return viewInsets.bottom > 0;
  }

  static Future<bool> isPhysicalDevice() async {
    return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }

  static void vibrate(Duration duration){
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }

  static Future<void> setPreferredOrientation(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  static void hideStatusBar(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  static void showStatusBar(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static bool isWebsite() {
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  static Future<double> getPackageInfo() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appVersion = packageInfo.version;
    // try {
    //   return double.parse(appVersion.substring(0,3));
    // } catch (e) {
    //   // Handle the exception if the string cannot be parsed as a float
    //   if (kDebugMode) {
    //     print('An Error happened in convert app version to double or in set sharePref');
    //     print('Error: $e');
    //   }
    // }
    return 1.0 ;
  }

  // static void launchUrl(String url) async {
  //   if(await canLaunchUrlString(url)){
  //     await launchUrlString(url);
  //   }else{
  //     throw 'Could not launch $url';
  //   }
  // }
}