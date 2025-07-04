import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_input.dart';
import 'package:tbc_application/util/validators/validation.dart';

class CustomAlertDialog {
  static confirmAdmin({
    required String title,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
    required TextEditingController controller,
  }) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      radius: 8,
      titlePadding: EdgeInsets.zero,
      titleStyle: TextStyle(fontSize: 0),
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    color: FColors.secondarySoft,
                    height: 150 / 100,
                  ),
                ),
              ],
            ),
          ),
          CustomInput(
            // margin: EdgeInsets.only(bottom: 24),
            controller: controller,
            label: 'password',
            hint: '*************',
            // obsecureText: true,
            onSaved: (String? val) => controller.text = val ?? '' ,
            validator: FValidation.validateEmail,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: onCancel,
                    child: Text(
                      "cancel",
                      style: TextStyle(color: FColors.secondarySoft),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      // primary: FColors.primaryExtraSoft,
                      elevation: 0,
                      // onPrimary: FColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    child: Text("confirm"),
                    style: ElevatedButton.styleFrom(
                      // primary: FColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  static showPresenceAlert({
    required String title,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
  }) {
    Get.defaultDialog(
      title: "",
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      radius: 8,
      titlePadding: EdgeInsets.zero,
      titleStyle: TextStyle(fontSize: 0),
      content: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 32, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    color: FColors.secondarySoft,
                    height: 150 / 100,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: onCancel,
                    child: Text(
                      "cancel",
                      style: TextStyle(color: FColors.secondarySoft),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      // primary: FColors.primaryExtraSoft,
                      elevation: 0,
                      // onPrimary: FColors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    child: Text("confirm"),
                    style: ElevatedButton.styleFrom(
                      // primary: FColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
