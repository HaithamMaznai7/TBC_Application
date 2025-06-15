import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/controllers/schedule_controller.dart';
import 'package:tbc_application/app/modules/schedule/views/maintenance/maintenance_view.dart';
import 'package:tbc_application/app/modules/schedule/views/visits/visits_view.dart';
import 'package:tbc_application/app/modules/schedule/views/widgets/schedule_days.dart';
import 'package:tbc_application/app/modules/schedule/views/widgets/schedule_header.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/app/widgets/custom_bottom_navigation_bar.dart';

class ScheduleView extends GetView<ScheduleController> {
    final List<Tab> _tabs = const [
      Tab(
        text: 'Maintenance'
      ),
      Tab(
        text: 'Visits'
      ),
    ];

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      widget: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          body: TabBarView(
            children: [
              // Visits Tab
              VisitsView(),

              // Maintenance Tab
              MaintenancesView(),
            ],
          ),
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            // Sliver AppBar with Collapsible Header
            SliverAppBar(
              backgroundColor: FColors.white,
              pinned: false,
              expandedHeight: 100.0,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: ScheduleHeader(),
              ),
            ),

            // Pinned ScheduleDays (Always visible when scrolling up)
            SliverPersistentHeader(
              pinned: true,
              delegate: ScheduleDaysDelegate(),
            ),

            // Sliver to hold the content of the TabView
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  tabs: _tabs,
                  labelColor: FColors.primary,
                  unselectedLabelColor: FColors.grey,
                  indicatorColor: FColors.primary,
                ),
              ),
            ),            
          ],
        ),
      ),
    );
  }
}


class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: FColors.white, // Background for the pinned TabBar
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return false;
  }
}