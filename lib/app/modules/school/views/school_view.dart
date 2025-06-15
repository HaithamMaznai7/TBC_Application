import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/school/views/tabs/information_tab.dart';
import 'package:tbc_application/app/modules/school/views/tabs/main.dart';
import 'package:tbc_application/app/modules/school/views/tabs/projects_tab.dart';
import 'package:tbc_application/util/constants/colors.dart';
import '../controllers/school_controller.dart';

class SchoolDetailsView extends GetView<SchoolDetailsController> {
  const SchoolDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: FColors.white,
        appBar: AppBar(
          backgroundColor: FColors.primary,
          title: Text(
            "${controller.school.value.name} Details",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: FColors.primaryExtraSoft,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Iconsax.location),
            ),
          ],
          bottom: TabBar(
            labelColor: FColors.secondary,
            unselectedLabelColor: Colors.white,
            indicatorColor: FColors.primary,
            tabs: const [
              Tab(text: 'Information', icon: Icon(Iconsax.home5)),
              Tab(text: 'Assets', icon: Icon(Iconsax.box)),
              Tab(text: 'Projects', icon: Icon(Iconsax.user)),
            ],
          ),
        ),
        body: TabBarView(
            children: [
              InformationTab(),
              MainTab(),
              ProjectsTab(),
            ],
          ),
        ),
    );
  }


}

// Custom SliverAppBarDelegate to pin the TabBar at the top
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: FColors.primary,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
