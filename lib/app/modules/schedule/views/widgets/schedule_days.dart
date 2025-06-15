import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/controllers/schedule_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:intl/intl.dart';
class ScheduleDaysDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 80.0;  // Adjusted height to include padding
  @override
  double get maxExtent => 100.0;  // Adjusted height to include padding

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      color: FColors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),  // Add 10px padding top and bottom
      child: Center(
        child: ScheduleDays(), 
      ),
    );
  }

  @override
  bool shouldRebuild(covariant ScheduleDaysDelegate oldDelegate) {
    return false;
  }
}
class ScheduleDays extends GetView<ScheduleController> {
  const ScheduleDays({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysRange = List.generate(101, (index) => index - 3); 
    return Material(
      color: FColors.white,
      child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final selectedDate = controller.selectedDate.value;

                return Row(
                  children: daysRange.map((offset) {
                    final date = today.add(Duration(days: offset));
                    final isSelected = selectedDate.day == date.day &&
                      selectedDate.month == date.month &&
                      selectedDate.year == date.year;

                    return SizedBox(
                      width: 70, // Adjust the width as needed
                      height: isSelected ? 70 : 60,
                      child: ChoiceChip(
                        label: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${date.day}", style: isSelected ? TextStyle(color: FColors.white) : TextStyle(color: FColors.primary)),
                              Text(DateFormat.MMMM().format(date), style: isSelected ? TextStyle(color: FColors.white) : TextStyle(color: FColors.primary)),
                            ],
                          ),
                        
                        selected: isSelected,
                        selectedColor: FColors.primary,
                        backgroundColor: date.day == today.day && date.month == today.month && date.year == today.year ? FColors.secondary : FColors.white,
                        showCheckmark: false,
                        onSelected: (_) { 
                          controller.selectedDate.value = date;
                          controller.selectedDate.refresh();
                        }
                      ),
                    );
                  }).toList(),
                );
              }),
            ));
          }
}
