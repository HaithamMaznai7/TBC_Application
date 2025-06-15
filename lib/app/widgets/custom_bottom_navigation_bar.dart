import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/controllers/page_index_controller.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/custom_app_bar.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/device/device_utility.dart';

class CustomBottomNavigationBar extends GetView<PageIndexController> {

  final Widget widget;
  final String? title;
  const CustomBottomNavigationBar({super.key, required this.widget, this.title});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: controller.pageIndex.value != 1 
        ? CustomCurvedAppBar(
          onSearch: () {

          },
          title: title ?? 'TBC Application',
          notificationCount: 0,
          onNotification: () {
            Get.toNamed(Routes.NOTIFICATION);
          },
          // onBack: () {
          //   Get.back();
          // },
        ) 
        : null,
      body: GestureDetector(
        onTap: controller.hideFabMenu,
        child: Obx((){
          final isShown = controller.showFabMenu.value;
          return Stack(
          children: [
            widget,
            if (isShown)
              Positioned(
                bottom: FDeviceUtils.getBottomNavigationBarHeight() * 2.2,
                left: MediaQuery.of(context).size.width / 2 - 80,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(FSizes.cardRadiusSm),
                  child: Container(
                    width: 160,
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: FColors.primaryExtraSoft,
                      borderRadius: BorderRadius.circular(FSizes.cardRadiusSm - 1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _fabMenuItem(Icons.note_add, 'Add School', () {
                          controller.hideFabMenu();
                          Get.toNamed(Routes.ADD_SCHOOL);
                          // Handle Add Note
                        }),
                        _fabMenuItem(Icons.task, 'Add Task', () {
                          controller.hideFabMenu();
                          // Handle Add Task
                        }),
                        _fabMenuItem(Icons.photo_camera, 'Add Photo', () {
                          controller.hideFabMenu();
                          // Handle Add Photo
                        }),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
        })
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: FColors.primary,
        onPressed: () => controller.toggleFabMenu(),
        child: Icon(Iconsax.add,color: FColors.white, size: 20,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: Container(
        height: FDeviceUtils.getBottomNavigationBarHeight() * 1.2,
        width: double.infinity,
        margin: EdgeInsets.only(
          bottom: 15,
          right: 15,
          left: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(FSizes.cardRadiusSm),
          boxShadow: [
            BoxShadow(
              color: FColors.primary.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: new FractionalOffset(.5, 1.0),
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.changePage(1),
                          child: Container(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.dashboard,
                                  color: (controller.pageIndex.value == 1) ? FColors.primary : FColors.darkerGrey,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: (controller.pageIndex.value == 1) ? FColors.primary : FColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.changePage(2),
                          child: Container(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: (controller.pageIndex.value == 0) ? SvgPicture.asset('assets/icons/home-active.svg') : SvgPicture.asset('assets/icons/home.svg'),
                                  margin: EdgeInsets.only(bottom: 1),
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: FColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.changePage(3),
                          child: Container(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: (controller.pageIndex.value == 0) ? SvgPicture.asset('assets/icons/home-active.svg') : SvgPicture.asset('assets/icons/home.svg'),
                                  margin: EdgeInsets.only(bottom: 1),
                                ),
                                Text(
                                  "Schools",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: FColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => controller.changePage(4),
                          child: Container(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: (controller.pageIndex.value == 2) ? SvgPicture.asset('assets/icons/profile-active.svg') : SvgPicture.asset('assets/icons/profile.svg'),
                                  margin: EdgeInsets.only(bottom: 1),
                                ),
                                Text(
                                  "more",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: FColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 32,
            //   child: Obx(
            //     () => SizedBox(
            //       width: 40,
            //       height: 40,
            //       child: FloatingActionButton(
            //         backgroundColor: FColors.primary,
            //         onPressed: () => controller.changePage(1),
            //         elevation: 0,
            //         child: Icon(
            //           Iconsax.add,color: FColors.white, size: 20,
            //         )
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ));
  }


  Widget _fabMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label, style: TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }

}
