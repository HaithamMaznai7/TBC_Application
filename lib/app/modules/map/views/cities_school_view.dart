import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/map/controllers/cities_school_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_bottom_navigation_bar.dart';

class CitiesSchoolView extends GetView<CitiesSchoolController> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      widget: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 30, left: 30, right: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade100,
                ),
                child: Obx(() {
                  if (controller.cities.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    children: [
                      // Services Slider
                      Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ChoiceChip(
                                label: Text('All'),
                                selected:
                                    controller.selectedRegion.value ==
                                    'All',
                                onSelected:
                                    (val) =>
                                        controller.filterByRegion('All'),
                              ),
                              ...controller.regions.map(
                                (region) => ChoiceChip(
                                  label: Text(region),
                                  selected:
                                      controller.selectedRegion.value == region,
                                  onSelected:
                                      (val) => controller.filterByRegion(region),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Maintenance Types List
                      Expanded(
                        child: Obx(
                          () => ListView.builder(
                            itemCount: controller.filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = controller.filteredCities[index];
                              return Card(
                                color: Colors.white,

                                child: InkWell(
                                  onTap: () => controller.selectCity(city), //Get.toNamed(Routes.CITY_SCHOOLS),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(.2),
                                    ),
                                    width: double.infinity,
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          city.image ??
                                              'https://th.bing.com/th/id/R.f422b1ca62feefb8e599bb32ee85d877?rik=FY9pSIl69wz0MA&pid=ImgRaw&r=0',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withOpacity(
                                                0.8,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Obx(() => Text(
                                                //       city.count.value,
                                                //       style: TextStyle(
                                                //         fontSize: 18,
                                                //         fontWeight: FontWeight.w700,
                                                //         color: FColors.secondaryDark,
                                                //       ),
                                                //     )),
                                                Text(
                                                  "${city.name}",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: FColors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
