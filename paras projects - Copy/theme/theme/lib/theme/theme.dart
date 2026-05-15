import 'package:flutter/material.dart';
import 'package:theme/colors.dart';
import 'package:theme/size_config.dart';

class AppTheme {
  final ThemeData primaryTheme = ThemeData(
    textTheme: TextTheme(
      displaySmall: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 1.2),
      bodySmall: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 1.4),
      bodyMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 1.6),
      bodyLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 1.8),
      displayLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.textMultiplier * 2),
      headlineSmall: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: SizeConfig.textMultiplier * 2.2),
      headlineMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: SizeConfig.textMultiplier * 2.5),
      headlineLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: SizeConfig.textMultiplier * 2.8),
    ),
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(primary: AppColors.black),
  );
  getTheme() {
    return primaryTheme;
  }
}
