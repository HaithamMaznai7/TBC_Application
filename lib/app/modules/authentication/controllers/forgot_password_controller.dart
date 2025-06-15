import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  final GlobalKey<FormState> passwordForgetFormKey = GlobalKey<FormState>();
  var email = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  void toggleLoading() => isLoading.toggle();

  Future<void> sendEmail() async {
    if (!isLoading.value) {
      toggleLoading();
      final isValid = passwordForgetFormKey.currentState!.validate();

      if (!isValid) {
        toggleLoading();
        return;
      }

      passwordForgetFormKey.currentState!.save();

      if (email.isNotEmpty) {
        try {
          auth.sendPasswordResetEmail(email: email);
          Get.back();
          CustomToast.successToast("Success", "We've send password reset link to your email");
        } catch (e) {
          CustomToast.errorToast("Error", "Cant send password reset link to your email. Error because : ${e.toString()}");
        } finally {
          toggleLoading();
        }
      } else {
        CustomToast.errorToast("Error", "Email must be filled");
      }
    }
  }
}
