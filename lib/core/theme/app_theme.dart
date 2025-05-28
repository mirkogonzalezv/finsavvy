import 'package:finsavvy/core/consts/theme_consts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color primaryColor = ThemeConstsApp.primaryColor;
  static final Color secondaryColor = ThemeConstsApp.secondaryColor;
  static final Color backgroundColor = ThemeConstsApp.backgroundColor;
  static final Color textColor = ThemeConstsApp.textColorPrimary;

  static final ThemeData theme = ThemeData().copyWith(
    textTheme: GoogleFonts.rubikTextTheme().apply(
      displayColor: textColor,
      bodyColor: secondaryColor,
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor),
    primaryColor: primaryColor,
  );
}
