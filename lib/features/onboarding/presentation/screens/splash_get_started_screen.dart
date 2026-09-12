import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        // Red square box with SP logo
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              'SP',
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // SpeechPro Brand Name
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Speech',
                                style: GoogleFonts.inter(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: AppColors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Pro',
                                style: GoogleFonts.inter(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // WINNING WITH WORDS
                        Text(
                          'WINNING WITH WORDS',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3.0,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Subtitle Description
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            'AI coaching for the speaking situations that define your career — built on proprietary coaching doctrine, not generic AI.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: const Color(0xFF707070),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
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
                              _buildFeatureItem('Power Through Speech'),
                              Divider(
                                height: 1.h,
                                thickness: 1.w,
                                color: const Color(0xFFE5E5EA),
                              ),
                              _buildFeatureItem('Influence Through Impact'),
                              Divider(
                                height: 1.h,
                                thickness: 1.w,
                                color: const Color(0xFFE5E5EA),
                              ),
                              _buildFeatureItem('Authority Through Presence'),
                            ],
                          ),
                        ),
                        const Spacer(flex: 3),
                        // Get Started Button
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(AppRoute.registration),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            child: Text(
                              'Get Started',
                              style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
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

  Widget _buildFeatureItem(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Row(
        children: [
          Image.asset(
            IconPath.onboarding,
            width: 22.w,
            height: 22.w,
            fit: BoxFit.contain,
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
