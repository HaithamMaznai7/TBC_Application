import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/contractors/controllers/contractors_controller.dart';
import 'package:tbc_application/app/modules/schools/models/supervisor.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_input.dart';
import 'package:tbc_application/app/widgets/custom_selection.dart';
import 'package:tbc_application/util/validators/validation.dart';


class AddContractorView extends GetView<ContractorsController> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${controller.contractor == null ? "Add" : "Edit"} Contractors',
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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          CustomInput(
            controller: controller.idC,
            label: 'Contractor ID',
            hint: '1000000001',
            onSaved: (String? val) => controller.idC.text = val ?? '',
            validator: FValidation.validateEmail,
          ),
          CustomInput(
            controller: controller.nameC,
            label: 'Full Name',
            hint: 'Johnn Doe',
            onSaved: (String? val) => controller.idC.text = val ?? '',
            validator: FValidation.validateEmail,
          ),
          CustomInput(
            controller: controller.emailC,
            label: 'Email',
            hint: 'youremail@email.com',
            onSaved: (String? val) => controller.idC.text = val ?? '',
            validator: FValidation.validateEmail,
          ),
          // EnumDropdown<WorkScop>(
          //   label: 'Work Scope',
          //   hint: 'Choose work scope',
          //   items: WorkScop.values,
          //   value: controller.contractor?.workScope ?? WorkScop.maintenance,
          //   getLabel: (status) => status.label,
          //   onChanged: (WorkScop? val) => controller.contractor!.workScope = val ?? controller.contractor!.workScope,
          // ),
          SizedBox(height: 8),
          CustomInput(
            controller: controller.jobC,
            label: 'Job',
            hint: 'Employee Job',
            onSaved: (String? val) => controller.idC.text = val ?? '',
            validator: FValidation.validateEmail,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.addContractor();
                  }
                },
                style: ElevatedButton.styleFrom(
                  // primary: FColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  (controller.isLoading.isFalse) 
                  ? '${controller.contractor == null ? "Create" : "Save"} Contractor' 
                  : 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
