import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AppTextFormFieldTheme {
  AppTextFormFieldTheme._();

  static final InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.gray,
    suffixIconColor: AppColors.gray,
    labelStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.black,
    ),
    hintStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.black,
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: AppColors.error,
    ),
    floatingLabelStyle: TextStyle(
      color: AppColors.black.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.divider),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.warning),
    ),
  );

  static final InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.gray,
    suffixIconColor: AppColors.gray,
    labelStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.white,
    ),
    hintStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.gray,
    ),
    errorStyle: const TextStyle(
      fontSize: 12,
      color: AppColors.error,
    ),
    floatingLabelStyle: TextStyle(
      color: AppColors.white.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.divider),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: AppColors.warning),
    ),
  );
}
