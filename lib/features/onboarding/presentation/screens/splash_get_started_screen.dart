import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                        SizedBox(height: 20.h),
                        // Top Brand Header
                        Text(
                          'welcome to',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                            color: const Color(0xFF767676),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Unboxed SP Logo Mark in its original intended shape
                        Image.asset(
                          ImagePath.spLogoMark,
                          width: 72.w,
                          height: 34.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8.h),
                        // SpeechPro Brand Name
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Speech',
                                style: GoogleFonts.inter(
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Pro',
                                style: GoogleFonts.inter(
                                  fontSize: 27.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'winning with words',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2.2,
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),

                        SizedBox(height: 28.h),

                        // Title and Description
                        Text(
                          'Before we begin — we want to\nlisten.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "SpeechPro doesn't start by telling you what\nto do. It starts by understanding what you\nactually need.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                            color: const Color(0xFF555555),
                          ),
                        ),

                        SizedBox(height: 28.h),

                        // Feature Pillars with red icons
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            children: [
                              _FeatureRow(
                                iconPath: IconPath.icFeatureMic,
                                label: 'Power through speech',
                              ),
                              SizedBox(height: 16.h),
                              _FeatureRow(
                                iconPath: IconPath.icFeatureBolt,
                                label: 'Influence through impact',
                              ),
                              SizedBox(height: 16.h),
                              _FeatureRow(
                                iconPath: IconPath.icFeatureCrown,
                                label: 'Authority through presence',
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),
                        SizedBox(height: 20.h),

                        // Primary Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(AppRoute.registration),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create account →',
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 14.h),

                        // Sign-in sub-link
                        GestureDetector(
                          onTap: () => Get.toNamed(AppRoute.login),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              'Already have an account? Sign in',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
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
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.iconPath,
    required this.label,
  });

  final String iconPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 22.w,
          height: 22.w,
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
