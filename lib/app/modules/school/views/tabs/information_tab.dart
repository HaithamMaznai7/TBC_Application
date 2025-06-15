import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/school/controllers/school_controller.dart';
import 'package:tbc_application/app/modules/school/views/widgets/address_section/address_section_body.dart';
import 'package:tbc_application/app/modules/school/views/widgets/assets_section.dart';
import 'package:tbc_application/app/modules/school/views/widgets/base_section.dart';
import 'package:tbc_application/app/modules/school/views/widgets/supervisor_section/supervisors_section.dart';
import 'package:tbc_application/app/modules/schools/controllers/schools_controller.dart';
import 'package:tbc_application/app/modules/schools/models/address.dart';
import 'package:tbc_application/util/constants/colors.dart';

class InformationTab extends GetView<SchoolDetailsController> {
  const InformationTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Title Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Iconsax.building, size: 40, color: FColors.primaryDark),
                    const SizedBox(width: 12),
                    Text(
                      "${controller.school.value.name} Details",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: FColors.primaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Information Row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoTile(Iconsax.location, "Address", '${controller.school.value.addressID}'),
                    _infoTile(Iconsax.call, "Contact", '${controller.school.value.group}'),
                    _infoTile(Iconsax.money, "Fees", controller.school.value.level.label),
                    _infoTile(Iconsax.calendar5, "Established", controller.school.value.type.label),
                    _infoTile(Iconsax.clipboard_text, "Type", '${controller.school.value.ministerialID}'),

                    // Obx((){
                    //   Address? address = controller.address.value;
                    //   SchoolController schoolController = Get.find<SchoolController>();

                    //   return AddressSectionBody(address: address, schoolController: schoolController);
                    // }),
                  ],
                ),
              ],
            ),
        ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: FColors.secondary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: FColors.primary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: FColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}