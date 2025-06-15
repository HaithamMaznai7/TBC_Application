
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_application/app/controllers/page_index_controller.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/dialog/custom_alert_dialog.dart';
import 'package:tbc_application/app/widgets/toast/custom_toast.dart';
import 'package:tbc_application/company_data.dart';
import 'package:tbc_application/main.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginController extends GetxController {
  final pageIndexController = Get.find<PageIndexController>();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  var email = '';
  var password = '';

  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  RxBool isPasswordVisible = false.obs;

  void toggleLoading() => isLoading.toggle();
  void toggleRememberMe() => rememberMe.toggle();
  void passwordVisibleChange() => isPasswordVisible.toggle();

  Future<void> checkDefaultPassword() async {
    if (password == CompanyData.defaultPassword) {
      Get.toNamed(Routes.NEW_PASSWORD);
    } else {
      await requestNotificationPermission();
      pageIndexController.changePage(0);
      Get.offAllNamed(Routes.HOME);
    }
  }

  void checkLogin() {
    if (!isLoading.value) {
      toggleLoading();
      final isValid = loginFormKey.currentState!.validate();

      if (!isValid) {
        toggleLoading();
        return;
      }

      loginFormKey.currentState!.save();
      login();
    }
  }

  void forgetPassword() {
    Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  Future<void> login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final credential = await auth.signInWithEmailAndPassword(email: email, password: password);

        if (credential.user != null) {
          if (credential.user!.emailVerified) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('remember', rememberMe.value);
            final idToken = await credential.user?.getIdToken();
            if (kIsWeb && idToken != null) {
              html.document.cookie = 'idToken=$idToken; path=/';
            }
            toggleLoading();
            checkDefaultPassword();
          } else {
            CustomAlertDialog.showPresenceAlert(
              title: "Email not yet verified",
              message: "Do you want to send email verification?",
              onCancel: () => Get.back(),
              onConfirm: () async {
                try {
                  await credential.user!.sendEmailVerification();
                  Get.back();
                  CustomToast.successToast("Success", "Email verification sent.");
                  toggleLoading();
                } catch (e) {
                  CustomToast.errorToast("Error", "Failed to send verification: ${e.toString()}");
                }
              },
            );
          }
        }
        // toggleLoading();
      } on FirebaseAuthException catch (e) {
        toggleLoading();
        if (e.code == 'user-not-found') {
          CustomToast.errorToast("Error", "Account not found");
        } else if (e.code == 'invalid-credential') {
          CustomToast.errorToast("Validated", "Wrong Email or/and Password");
        }else{
          CustomToast.errorToast(e.code, "Invalidate Login Credentials on Backend: ${e.message}");
        }
      } catch (e) {
        CustomToast.errorToast("Error", "Login error: ${e.toString()}");
      }
    } else {
      CustomToast.errorToast("Error", "Please fill in email and password");
    }
  }
}

