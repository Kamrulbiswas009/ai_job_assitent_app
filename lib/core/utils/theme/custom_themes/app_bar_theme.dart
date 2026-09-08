import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  static const AppBarTheme lightAppBarTheme = AppBarTheme(
    foregroundColor: AppColors.transparent,
    surfaceTintColor: AppColors.transparent,
    elevation: 0,
    backgroundColor: AppColors.white,
    iconTheme: IconThemeData(color: AppColors.black),
    titleTextStyle: TextStyle(
      color: AppColors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: IconThemeData(color: AppColors.black),
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );

  static final AppBarTheme darkAppBarTheme = AppBarTheme(
    foregroundColor: AppColors.transparent,
    surfaceTintColor: AppColors.transparent,
    elevation: 0,
    backgroundColor: AppColors.backgroundDark,
    iconTheme: const IconThemeData(color: AppColors.white),
    titleTextStyle: const TextStyle(
      color: AppColors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    actionsIconTheme: const IconThemeData(color: AppColors.white),
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}

