import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFCC0000); // SpeechPro Primary Red
  static const Color primaryDark = Color(0xFF1E3A5F);
  static const Color secondary = Color(0xFFFEC601);
  static const Color accent = Color(0xFF89A7FF);

  // Core Neutrals
  static const Color black = Color(0xFF0A0A0A);
  static const Color pureBlack = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFF888888);
  static const Color placeholder = Color(0x420A0A0A); // ~26% opacity
  static const Color surfaceGray = Color(0xFFF7F7F7);
  static const Color border = Color(0x1F000000); // ~12% opacity
  static const Color divider = Color(0x14000000); // ~8% opacity

  // Feature Colors
  static const Color purple = Color(0xFF8200E2);
  static const Color purpleSoft = Color(0xFFFAF5FF);

  // Gradient Colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xFFFF9A9E),
      Color(0xFFFAD0C4),
      Color(0xFFFAD0C4),
    ],
  );

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Common Constants
  static const Color transparent = Colors.transparent;

  // Background Colors
  static const Color backgroundLight = Color(0xFFF9FAFB);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color primaryBackground = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFE0E0E0);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Container Colors
  static const Color lightContainer = Color(0xFFF1F8E9);

  // Utility Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF29B6F6);
}