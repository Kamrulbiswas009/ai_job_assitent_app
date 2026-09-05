import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/onboarding_assets.dart';
import '../constants/onboarding_colors.dart';
import 'splash_get_started_screen.dart';

class SplashLogoScreen extends StatefulWidget {
  const SplashLogoScreen({super.key});

  @override
  State<SplashLogoScreen> createState() => _SplashLogoScreenState();
}

class _SplashLogoScreenState extends State<SplashLogoScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Get.offNamed(SplashGetStartedScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            OnboardingAssets.spLogoMark,
            width: 208.w,
            height: 99.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
