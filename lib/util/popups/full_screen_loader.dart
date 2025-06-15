import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FFullScreenLoader{
  static void openLoadingDialog({required Widget page}){
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: page
        ),
    );
  }

  static stopLoading(){
    Navigator.of(Get.context!).pop();
  }
}