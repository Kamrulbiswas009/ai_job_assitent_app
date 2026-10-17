import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../core/utils/logging/logger.dart';
import '../../../../routes/app_routes.dart';

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
      _resolveInitialRoute();
    });
  }

  void _resolveInitialRoute() {
    // If the user still has a valid auth token, skip login entirely
    if (StorageService.hasToken()) {
      AppLoggerHelper.info(
        'Token found – restoring session without login.',
      );

      // If there's a saved session snapshot, resume exactly where they left
      if (StorageService.hasSavedSession()) {
        final saved = StorageService.getLastSession();
        if (saved != null) {
          // Restore assessmentId if it was saved with the session
          if (saved.assessmentId != null &&
              saved.assessmentId!.isNotEmpty) {
            StorageService.saveAssessmentId(saved.assessmentId!);
          }
          StorageService.clearSavedSession();
          Get.offAllNamed(saved.route, arguments: saved.arguments);
          return;
        }
      }

      // No saved session but token exists → go to default practice screen
      Get.offAllNamed(AppRoute.practiceSessionReady);
    } else {
      // No token – first launch or logged out, show onboarding
      Get.offNamed(AppRoute.splashGetStarted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            ImagePath.spLogoMark,
            width: 208.w,
            height: 99.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
