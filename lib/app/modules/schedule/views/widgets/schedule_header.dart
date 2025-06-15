import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/controllers/schedule_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/formatters/formatter.dart';

class ScheduleHeader extends GetView<ScheduleController> {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FColors.white,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        // margin: margin,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: FColors.secondaryExtraSoft),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: FColors.primaryExtraSoft),
                const SizedBox(width: 8),
                Text(
                  EFormatter.getDateFormat.format(DateTime.now()),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => controller.openEventDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: FColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Add Event', style: TextStyle(color: Colors.white)),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}
