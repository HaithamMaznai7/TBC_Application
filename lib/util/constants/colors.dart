import 'package:flutter/material.dart';

class FColors{

  // App Basic Colors
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0F50C6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const Color primary =  Color(0xff009DA9);
  static const Color primaryDark =  Color(0xff016F75);
  static const Color primarySoft =  Color(0xFF6ACED5);
  static const Color primaryExtraSoft = Color(0xFFB1E0E3);
  static const Color secondary = Color.fromARGB(255, 255, 196, 0);
  static const Color secondaryDark = Color.fromARGB(255, 252, 201, 34);
  static const Color secondarySoft = Color.fromARGB(255, 252, 230, 157);
  static const Color secondaryExtraSoft = Color.fromARGB(255, 249, 241, 214);
  static const Color grey = Color.fromARGB(255, 219, 217, 209);
  static const Color error = Color(0xFFD00E0E);
  static const Color success = Color(0xFF16AE26);
  static const Color inf = Color(0xFF2A73B6);
  static const Color warning = Color(0xFFFED759);
  // Gradient Colors
  // static const LinearGradient primaryGradient = LinearGradient(
  // colors: [primaryGradientColor, primaryColor],
  // begin: Alignment.topLeft,
  // end: Alignment.bottomRight,
  // );
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF382723), Color(0xFF003145)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Colors
  static const Color textPrimary = Color(0xFF091747);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF292929);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color secondaryBackground = Color(0xFF003145);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF4F1eB);
  static Color darkContainer = FColors.white.withOpacity(0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFFF56969);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisable = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and Validation Colors

  static const Color info = Color(0xFF1976D2);

  // Error and Validation Colors
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFF4F1EB);

}