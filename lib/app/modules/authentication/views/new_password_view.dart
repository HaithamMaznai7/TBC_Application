import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/common/styles/spaecing_style.dart';
import 'package:tbc_application/common/widgets/logo.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/constants/text_strings.dart';
import 'package:tbc_application/util/validators/validation.dart';
import 'package:tbc_application/app/modules/authentication/controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_right_3),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
                            LoginPage.newPasswordTitle.tr,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            LoginPage.newPasswordSubTitle.tr,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: controller.newPasswordFormKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: FSizes.spaceBtwSections),
                        child: Column(
                          children: [
                            Obx(() => TextFormField(
                              obscureText: controller.isNewPasswordVisible.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Iconsax.password_check),
                                labelText: LoginPage.newPassword.tr,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isNewPasswordVisible.value
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                  ),
                                  onPressed: controller.newPasswordVisibleChange,
                                ),
                              ),
                              controller: controller.newPassC,
                              onSaved: (value) => controller.newPassword = value!,
                              validator: FValidation.validatePassword,
                            )),
                            const SizedBox(height: FSizes.spaceBtwInputFields),
                            Obx(() => TextFormField(
                              obscureText: controller.isConfirmedPasswordVisible.value,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Iconsax.password_check),
                                labelText: LoginPage.confirmedPassword.tr,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isConfirmedPasswordVisible.value
                                        ? Iconsax.eye
                                        : Iconsax.eye_slash,
                                  ),
                                  onPressed: controller.confirmedPasswordVisibleChange,
                                ),
                              ),
                              controller: controller.confirmedPassC,
                              onSaved: (value) => controller.confirmedPassword = value!,
                              validator: FValidation.validatePassword,
                            )),
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
                                child: ElevatedButton(onPressed: controller.saveNewPassword , child: Text(LoginPage.saveNewPassword.tr,style: Theme.of(context).textTheme.headlineSmall?.apply(color: FColors.white),))
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
