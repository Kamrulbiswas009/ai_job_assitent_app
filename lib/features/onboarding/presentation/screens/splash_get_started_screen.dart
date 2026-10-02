import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../routes/app_routes.dart';

class SplashGetStartedScreen extends StatelessWidget {
  const SplashGetStartedScreen({super.key});

  static const String routeName = '/splash-get-started';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        const Spacer(flex: 1),

                        // Welcome to
                        Text(
                          'Welcome to',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // SP Logo Mark
                        Image.asset(
                          ImagePath.spLogoMark,
                          width: 64.w,
                          height: 30.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 12.h),

                        // SpeechPro Wordmark (with WINNING WITH WORDS)
                        Image.asset(
                          ImagePath.spLogoWordmark,
                          width: 240.w,
                          height: 70.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 26.h),

                        // Title Headline
                        Text(
                          'Before we begin — we want to\nlisten.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 19.5.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.28,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Subtitle Description
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            "SpeechPro doesn't start by telling you what\nto do. It starts by understanding what you\nactually need.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        SizedBox(height: 20.h),

                        // Feature list with dividers
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: const Color(0xFFE5E5EA),
                                width: 1.w,
                              ),
                              bottom: BorderSide(
                                color: const Color(0xFFE5E5EA),
                                width: 1.w,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildFeatureItem(
                                iconPath: IconPath.icFire,
                                title: 'Power Through Speech',
                              ),
                              Divider(
                                height: 1.h,
                                thickness: 1.w,
                                color: const Color(0xFFE5E5EA),
                              ),
                              _buildFeatureItem(
                                iconPath: IconPath.icBoltColor,
                                title: 'Influence Through Impact',
                              ),
                              Divider(
                                height: 1.h,
                                thickness: 1.w,
                                color: const Color(0xFFE5E5EA),
                              ),
                              _buildFeatureItem(
                                iconPath: IconPath.icCrownColor,
                                title: 'Authority Through Presence',
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 2),
                        SizedBox(height: 20.h),

                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(AppRoute.registration),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Create account',
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // Already have an account? Sign In
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoute.login),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF8E8E93),
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Already have an account? ',
                                  ),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required String iconPath, required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 8.w),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24.w,
            height: 24.w,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => SizedBox(
              width: 24.w,
              height: 24.w,
              child: Icon(
                Icons.check_circle_outline,
                size: 20.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
