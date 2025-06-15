import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/common/styles/spaecing_style.dart';
import 'package:tbc_application/common/widgets/logo.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/authentication/controllers/login_controller.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/constants/text_strings.dart';
import 'package:tbc_application/util/helpers/helper_functions.dart';
import 'package:tbc_application/util/localization/localization.dart';
import 'package:tbc_application/util/validators/validation.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FHelper.isDarkMode(context) ? FColors.dark : FColors.white,
        automaticallyImplyLeading: false,
        leading: FLocalization.localizeIcon(),
        leadingWidth: 35,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: FSpacingStyle.paddingWithAppBarHeight,
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Logo(height: 80),
                          const SizedBox(height: FSizes.spaceBtwItems),
                          Text(
                            LoginPage.loginTitle.tr,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            LoginPage.loginSubTitle.tr,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: controller.loginFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: FSizes.spaceBtwSections),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Iconsax.user),
                                labelText: LoginPage.username.tr,
                              ),
                              controller: controller.emailC,
                              onSaved: (value) => controller.email = value!,
                              validator: FValidation.validateEmail,
                            ),
                            const SizedBox(height: FSizes.spaceBtwInputFields),
                            Obx(() => TextFormField(
                              obscureText: controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Iconsax.password_check),
                                labelText: LoginPage.password.tr,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                  ),
                                  onPressed: controller.passwordVisibleChange,
                                ),
                              ),
                              controller: controller.passC,
                              onSaved: (value) => controller.password = value!,
                              validator: FValidation.validatePassword,
                            )),
                            const SizedBox(height: FSizes.spaceBtwInputFields / 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Obx(
                                      () => Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (value){
                                          controller.rememberMe.toggle();
                                        },
                              )
                                    ),
                                    Text(LoginPage.rememberMe.tr, style: Theme.of(context).textTheme.bodyLarge,),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: FSizes.spaceBtwInputFields / 2),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: controller.forgetPassword,
                                  style: TextButton.styleFrom(
                                    foregroundColor: FColors.inf,
                                  ),
                                  child: Text(LoginPage.forgetPassword.tr),
                                ),
                              ],
                            ),
                            const SizedBox(height: FSizes.spaceBtwSections),
                            Obx((){
                              final isLoad = controller.isLoading.value;

                              if(isLoad){
                                return Container(
                                  decoration: BoxDecoration(
                                    color: FColors.primary,
                                    borderRadius: BorderRadius.circular(
                                      FSizes.borderRadiusMd,
                                    )
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: FSizes.sm),
                                  width: double.infinity,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: FColors.white,
                                    )
                                  )
                                );
                              }

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(onPressed: controller.checkLogin , child: Text(LoginPage.signIn.tr,style: Theme.of(context).textTheme.headlineSmall?.apply(color: FColors.white),))
                              );
                            }),
                          
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
