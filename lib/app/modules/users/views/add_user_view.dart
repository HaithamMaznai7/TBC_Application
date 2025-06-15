import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';
import 'package:tbc_application/app/modules/users/controllers/users_controller.dart';
import 'package:tbc_application/app/modules/users/models/users.dart';
import 'package:tbc_application/app/widgets/custom_selection.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_input.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/validators/validation.dart';


class AddUserView extends GetView<UsersController> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${controller.user == null ? "Add" : "Edit"} User',
          style: TextStyle(
            color: FColors.secondary,
            fontSize: 14,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/icons/arrow-left.svg'),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: FColors.secondaryExtraSoft,
          ),
        ),
      ),
      body: Form(
        key: controller.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: FSizes.spaceBtwSections, horizontal: FSizes.md),
          child: Column(
            children: [
              CustomInput(
                controller: controller.idC,
                label: 'ID',
                hint: '1000000001',
                onSaved: (String? val) => controller.user.employeeId = val,
                validator: (String? value) => FValidation.validateRequired('ID', value),
              ),
              SizedBox(height: FSizes.spaceBtwInputFields),
              CustomInput(
                controller: controller.nameC,
                label: 'Full Name',
                hint: 'Johnn Doe',
                onSaved: (String? val) => controller.user.fullname = val,
                validator: (String? value) => FValidation.validateRequired('Full Name', value),
              ),
              SizedBox(height: FSizes.spaceBtwInputFields),
              CustomInput(
                controller: controller.emailC,
                label: 'Email',
                hint: 'youremail@email.com',
                onSaved: (String? val) => controller.user.email = val,
                validator: FValidation.validateEmail,
              ),
              SizedBox(height: FSizes.spaceBtwInputFields),
              CustomInput(
                controller: controller.mobileC,
                label: 'Mobile',
                hint: '5########',
                onSaved: (String? val) => controller.user.phoneNumber = val,
                validator: (String? value) => FValidation.validateRequired('Mobile', value),
              ),
              SizedBox(height: FSizes.spaceBtwInputFields),
              CustomInput(
                controller: controller.jobC,
                label: 'Job',
                hint: 'User Job',
                onSaved: (String? val) => controller.user.job = val,
                validator: (String? value) => FValidation.validateRequired('Job', value),
              ),
              SizedBox(height: FSizes.spaceBtwInputFields),
              EnumDropdown<UserRole>(
                label: 'User Role',
                hint: 'Choose user role',
                items: UserRole.values,
                value: controller.user.role,
                getLabel: (status) => status.label,
                onChanged: (UserRole? val) => controller.user.role = val ?? controller.user.role,
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
                  child: ElevatedButton(onPressed: controller.checkSave , child: Text('${controller.user == null ? "Create" : "Save"} User'.tr,style: Theme.of(context).textTheme.headlineSmall?.apply(color: FColors.white),))
                );
              }),                  
            ],
          ),
        ),
      ),
    );
  }
}
