import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.gray;
          }
          return AppColors.white;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.surfaceLight;
          }
          return AppColors.primary;
        },
      ),
      side: WidgetStateProperty.all(
        const BorderSide(color: AppColors.primary),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 18),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.all(0),
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.gray;
          }
          return AppColors.white;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.surfaceDark;
          }
          return AppColors.primary;
        },
      ),
      side: WidgetStateProperty.all(
        const BorderSide(color: AppColors.primary),
      ),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 18),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
