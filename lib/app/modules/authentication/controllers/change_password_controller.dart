import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';

class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  TextEditingController oldPassC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmedPassC = TextEditingController();

  RxBool isOldPasswordVisible = false.obs;
  RxBool isNewPasswordVisible = false.obs;
  RxBool isConfirmedPasswordVisible = false.obs;

  void toggleLoading() => isLoading.toggle();
  void oldPasswordVisibleChange() => isOldPasswordVisible.toggle();
  void newPasswordVisibleChange() => isNewPasswordVisible.toggle();
  void confirmedPasswordVisibleChange() => isConfirmedPasswordVisible.toggle();


  var oldPassword = '';
  var newPassword = '';
  var confirmedPassword = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updatePassword() async {
    if (!isLoading.value) {
      toggleLoading();
      final isValid = changePasswordFormKey.currentState!.validate();

      if (!isValid) {
        toggleLoading();
        return;
      }

      changePasswordFormKey.currentState!.save();
      if (oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmedPassword.isNotEmpty) {
        if (newPassword == confirmedPassword) {
          try {
            String emailUser = auth.currentUser!.email!;
            // checking if the current password is true
            await auth.signInWithEmailAndPassword(email: emailUser, password: oldPassword);
            // update password
            await auth.currentUser!.updatePassword(newPassword);

            Get.back();
            CustomToast.successToast('Success', 'success change password');
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password') {
              CustomToast.errorToast('Error', 'current password wrong');
            } else {
              CustomToast.errorToast('Error', 'cant update password because : ${e.code}');
            }
          } catch (e) {
            CustomToast.errorToast('Error', 'error : ${e.toString()}');
          } finally {
            toggleLoading();
          }
        } else {
          newPassC.clear();
          confirmedPassC.clear();
          CustomToast.errorToast('Error', 'new password and confirm password doesnt match');
        }
      } else {
        CustomToast.errorToast('Error', 'all form must be filled');
      }
    }
  }
}
