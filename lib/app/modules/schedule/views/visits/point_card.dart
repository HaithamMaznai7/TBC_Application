
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:tbc_application/app/modules/schedule/models/point.dart';
import 'package:tbc_application/app/modules/schedule/views/visits/note_dialog.dart';
import 'package:tbc_application/app/modules/schedule/views/visits/note_dialog_controller.dart';
import 'package:tbc_application/util/constants/colors.dart';
import 'package:tbc_application/util/constants/sizes.dart';
import 'package:tbc_application/util/helpers/helper_functions.dart';
import 'package:tbc_application/util/localization/localization.dart';

class PointCard extends StatelessWidget {
  final Point point;

  const PointCard({super.key, required this.point});

  @override
  Widget build(BuildContext context) {
    final isDark = FHelper.isDarkMode(context);
    IconData icon = Icons.not_interested;
    Color color = Colors.grey;

    switch (point.status) {
      case PointStatus.completed:
        icon = Icons.gpp_good;
        color = FColors.success;
        break;
      case PointStatus.note:
        icon = Icons.edit;
        color = FColors.warning;
        break;
      case PointStatus.review:
        icon = Icons.edit;
        color = FColors.warning;
        break;
      case PointStatus.none:
        icon = Icons.not_interested;
        color = isDark ? FColors.grey : FColors.darkGrey;
        break;
    }

    return Slidable(
      key: ValueKey('slidable_${point.id}'),  // Unique key for the entire Slidable
      closeOnScroll: true,
      startActionPane: ActionPane(
        motion: const StretchMotion(),
        extentRatio: .7,
        children: [
          SlidableAction(
            autoClose: true,
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: FColors.success,
            icon: Icons.gpp_good,
            onPressed: (context) => _setStatus(),
          ),
          SlidableAction(
            autoClose: true,
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: FColors.warning,
            icon: Icons.edit,
            onPressed: (context) => _setStatus(),
          ),
          SlidableAction(
            autoClose: true,
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: isDark ? FColors.darkGrey : FColors.darkGrey,
            icon: Icons.not_interested,
            onPressed: (context) => _setStatus(),
          ),
        ],
      ),
      child: InkWell(
        onTap: openStatusSelector,
        child: Card(
          color: isDark ? FColors.grey.withOpacity(.2) : FColors.buttonSecondary,
          child: Padding(
            padding: point.status == PointStatus.review
                ? const EdgeInsetsDirectional.only(top: FSizes.lg)
                : const EdgeInsets.all(FSizes.lg),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    point.status == PointStatus.review
                        ? const SizedBox()
                        : Text(
                            point.status.toString(),
                            style: Theme.of(context).textTheme.titleLarge?.apply(
                                  color: color,
                                ),
                          ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        FLocalization.isArabic
                            ? point.title.toString()
                            : point.title.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: FColors.grey,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    point.status == PointStatus.review
                      ? SizedBox()
                      : Icon(icon, color: color),
                  ],
                ),
                SizedBox(
                  height: point.status == PointStatus.review ? FSizes.lg : 0,
                ),
                point.status == PointStatus.review
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: FSizes.sm, horizontal: FSizes.lg),
                        decoration: BoxDecoration(
                          color: FColors.warning.withOpacity(.1),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              point.status.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.apply(color: color),
                            ),
                            Text(
                              point.userNote.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.apply(
                                    color: FColors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Icon(icon, color: color),
                          ],
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setStatus() async {
    Get.to(
      () => InspectionNotesView(
        point: point,
        role: 'supervisor',
      ),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<InspectionNotesController>()) {
          Get.lazyPut(() => InspectionNotesController());
        }
      }),
    );
  }

  openStatusSelector() {
    Get.bottomSheet(
      isScrollControlled: true,
      FractionallySizedBox(
        child: SingleChildScrollView(
          child: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: FSizes.sm),
              child: Column(
                children: [
                  _buildStatusOption('Good', PointStatus.completed, FColors.success),
                  _buildStatusOption('Note', PointStatus.note, FColors.warning),
                  _buildStatusOption('N/A', PointStatus.none, FColors.darkGrey.withOpacity(.4)),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: FHelper.isDarkMode(Get.context!) ? FColors.dark : Colors.white,
    ).then((value) => value != null ? _setStatus() : null);
  }

  Widget _buildStatusOption(String title, PointStatus status, Color color) {
    return InkWell(
      onTap: () => Get.back(result: status),
      child: SizedBox(
        height: 60,
        child: Card(
          color: color,
          child: Center(
            child: Text(
              title.tr,
              style: Theme.of(Get.context!).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
    );
  }
}
