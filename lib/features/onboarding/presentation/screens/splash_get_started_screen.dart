import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/sp_primary_button.dart';

class SplashGetStartedScreen extends StatelessWidget {
  const SplashGetStartedScreen({super.key});

  static const String routeName = '/splash-get-started';

  static const _points = [
    'Power Through Speech',
    'Influence Through Impact',
    'Authority Through Presence',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 21.w),
          child: Column(
            children: [
              SizedBox(height: 120.h),
              Column(
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    color: AppColors.primary,
                    alignment: Alignment.center,
                    child: Image.asset(
                      ImagePath.spMarkWhite,
                      width: 34.w,
                      height: 16.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Image.asset(
                    ImagePath.spLogoWordmark,
                    width: 333.w,
                    height: 120.h,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    'AI coaching for the speaking situations that define your career — built on proprietary coaching doctrine, not generic AI.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 56.h),
              Container(
                width: 352.w,
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: Column(
                  children: List.generate(_points.length, (index) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.divider),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            color: AppColors.primary,
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: GoogleFonts.inter(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w900,
                                height: 1.5,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            _points[index],
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const Spacer(),
              SpPrimaryButton(
                label: 'Get Started',
                onPressed: () => Get.toNamed(AppRoute.login),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
