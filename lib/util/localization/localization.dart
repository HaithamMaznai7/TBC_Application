import '../constants/colors.dart';
import 'arabic.dart';
import 'english.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': _Local.en,
    'ar': _Local.ar
  };

  static Widget localizeIcon(){
    return  IconButton(
      padding: FLocalization.isArabic ? const EdgeInsets.only(right: 20) : const EdgeInsets.only(left: 20) ,
      icon: const Icon(Icons.translate),
      color: FColors.primary,
      onPressed: () => changeLocale(),
    );
  }

  static changeLocale() {
    if (isArabic) {
      Get.updateLocale(const Locale('en'));
    } else {
      Get.updateLocale(const Locale('ar'));
    }
  }

  static bool get isArabic => Get.locale?.languageCode == 'ar' ;
}

class _Local{
  static Map<String,String> en = English.en ;
  static Map<String,String> ar = Arabic.ar ;
}
