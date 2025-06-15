import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tbc_application/app/modules/home/controllers/home_controller.dart';
import 'package:tbc_application/app/modules/notifications/controllers/notification_controller.dart';
import 'package:tbc_application/app/routes/app_pages.dart';
import 'package:tbc_application/app/widgets/custom_bottom_navigation_bar.dart';
import 'package:badges/badges.dart' as custom_badge;
import 'package:tbc_application/util/constants/colors.dart';

class ChartCard extends StatelessWidget {
  final String title;
  final String? description;
  final Widget body;
  final List<String> actions;
  final void Function(String) onActionSelected;

  const ChartCard({
    super.key,
    required this.title,
    required this.description,
    required this.body,
    this.actions = const [],
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                actions.isNotEmpty ? PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: onActionSelected,
                  itemBuilder: (context) => actions
                      .map((action) => PopupMenuItem<String>(
                            value: action,
                            child: Text(action),
                          ))
                      .toList(),
                ) : SizedBox(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            description != null ? Text(
              description!,
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ) : SizedBox(),
            const SizedBox(height: 16),
            body,
          ],
        ),
      ),
    );
  }
}


Widget buildPieChart(List<PieChartSectionData> sections) {
  return SizedBox(
    height: 200,
    child: PieChart(
      PieChartData(sections: sections),
    ),
  );
}

Widget buildBarChart(List<BarChartGroupData> barGroups) {
  return SizedBox(
    height: 200,
    child: BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}

Widget buildLineChart(List<FlSpot> spots) {
  return SizedBox(
    height: 200,
    child: LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            // colors: [Colors.pink],
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    ),
  );
}


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  void _handleAction(String action) {
    print('Selected action: $action');
  }

  Widget build(BuildContext context) {
    NotificationController notificationController = Get.put(NotificationController());
    return CustomBottomNavigationBar(
      widget: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              Map<String, dynamic> user = snapshot.data!.data()!;
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                children: [
                  // Section 1 - Welcome Back
      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الأربعاء، 6 شعبان 1446',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: notificationController.streamNotifications(),
                              builder: (context, snapshot) {
                                int notificationCount = 0;
                                if (snapshot.hasData) {
                                  notificationCount = snapshot.data!.docs.length;
                                }
                                return custom_badge.Badge(
                                  position: custom_badge.BadgePosition.topEnd(top: -10, end: -10),
                                  showBadge: notificationCount > 0,
                                  badgeContent: Text(
                                    '$notificationCount',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: IconButton(
                                    onPressed: () => Get.toNamed(Routes.NOTIFICATION),
                                    icon: Icon(Icons.notifications),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                width: 42,
                                height: 42,
                                child: Image.network(
                                  (user["avatar"] == null || user['avatar'] == "") ? "https://ui-avatars.com/api/?name=${user['fullname']}/" : user['avatar'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () => Get.toNamed(Routes.PROFILE),
                                  child: Text(
                                    user["fullname"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'poppins',
                                    ),
                                  )
                                ),
                                
                                Text(
                                  user["job"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'نتمنى يوما جيدا لك',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
      
  
                  // section 3 distance & map

                ...[0,1,2,3,4].map(
                  (index) => ChartCard(
                    title: _getTitle(index),
                    description: _getDescription(index),
                    body: _getChart(index),
                    // actions: ['Refresh', 'Details', 'Remove'],
                    onActionSelected: _handleAction,
                  )
                ),
      
                ],
              );

            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return Center(child: Text("Error"));
          }
        })
    );
  }
  
  
  String _getTitle(int index) {
    switch (index) {
      case 0:
        return "Projects Overview";
      case 1:
        return "Project Status";
      case 2:
        return "Visits Distribution";
      case 3:
        return "Earnings Overview";
      case 4:
        return "Employee Distribution";
      default:
        return "Chart";
    }
  }

  String _getDescription(int index) {
    switch (index) {
      case 0:
        return "Percentage of completed, in-progress, and pending tasks.";
      case 1:
        return "Number of open, closed, and ongoing projects.";
      case 2:
        return "Visits to project sites.";
      case 3:
        return "Financial gains from projects.";
      case 4:
        return "Supervisors vs. workers ratio.";
      default:
        return "Chart data description.";
    }
  }

  Widget _getChart(int index) {
    switch (index) {
      case 0:
        return buildPieChart([
          PieChartSectionData(value: 40, color: Colors.blue, title: '40%'),
          PieChartSectionData(value: 30, color: Colors.orange, title: '30%'),
          PieChartSectionData(value: 30, color: Colors.green, title: '30%'),
        ]);
      case 1:
        return buildBarChart([
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: 8, color: Colors.purple),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: 6, color: Colors.cyan),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: 4, color: Colors.yellow),
          ]),
        ]);
      case 2:
        return buildLineChart([
          const FlSpot(0, 1),
          const FlSpot(1, 3),
          const FlSpot(2, 2),
          const FlSpot(3, 5),
        ]);
      default:
        return const Text("Chart not available");
    }
  }
}
