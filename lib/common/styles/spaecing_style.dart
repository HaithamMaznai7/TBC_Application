import 'package:tbc_application/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class FSpacingStyle{
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: FSizes.appBarHeight,
    right: FSizes.defaultSpace,
    bottom: FSizes.defaultSpace,
    left: FSizes.defaultSpace
  );
}