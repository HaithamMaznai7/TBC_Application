import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/controllers/page_index_controller.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';
import 'package:tbc_application/company_data.dart';

class NewPasswordController extends GetxController {
  final pageIndexController = Get.find<PageIndexController>();
  RxBool isLoading = false.obs;

  final GlobalKey<FormState> newPasswordFormKey = GlobalKey<FormState>();

  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmedPassC = TextEditingController();

  RxBool isNewPasswordVisible = false.obs;
  RxBool isConfirmedPasswordVisible = false.obs;

  void toggleLoading() => isLoading.toggle();
  void newPasswordVisibleChange() => isNewPasswordVisible.toggle();
  void confirmedPasswordVisibleChange() => isConfirmedPasswordVisible.toggle();

  var newPassword = '';
  var confirmedPassword = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  void saveNewPassword() async {
    if (!isLoading.value) {
      toggleLoading();
      final isValid = newPasswordFormKey.currentState!.validate();

      if (!isValid) {
        toggleLoading();
        return;
      }

      newPasswordFormKey.currentState!.save();
      if (newPassword.isNotEmpty && confirmedPassword.isNotEmpty) {
        if (newPassword == confirmedPassword) {
          if (newPassword != CompanyData.defaultPassword) {
            _updatePassword();
          } else {
            CustomToast.errorToast('Error', 'you must change your password');
            toggleLoading();
          }
        } else {
          CustomToast.errorToast('Error', 'password doesnt match');
          toggleLoading();
        }
      } else {
        CustomToast.errorToast('Error', 'you must fill all form');
        toggleLoading();
      }
    }
  }

  void _updatePassword() async {
    try {
      String email = auth.currentUser!.email!;
      await auth.currentUser!.updatePassword(newPassword);
      // relogin
      await auth.signOut();
      await auth.signInWithEmailAndPassword(email: email, password: newPassword);
      Get.offAllNamed(Routes.HOME);

      pageIndexController.changePage(0);
      CustomToast.successToast('success', 'success update password');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomToast.errorToast('Error', 'password too weak, you need at least six charachter');
      }
    } catch (e) {
      CustomToast.errorToast('Error', 'error : ${e.toString()}');
    }finally {
      toggleLoading();
    }
  }
}
