import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/onboarding_assets.dart';
import '../constants/onboarding_colors.dart';

enum OnboardingHeaderStyle { logo, backOnly }

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({
    super.key,
    this.style = OnboardingHeaderStyle.logo,
    this.onBack,
  });

  final OnboardingHeaderStyle style;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        if (style == OnboardingHeaderStyle.logo)
          Row(
            children: [
              _BackCircle(onTap: onBack ?? Get.back),
              SizedBox(width: 8.w),
              Image.asset(
                OnboardingAssets.logoHeader,
                width: 103.w,
                height: 30.h,
                fit: BoxFit.contain,
              ),
            ],
          )
        else
          Row(
            children: [
              _BackCircle(onTap: onBack ?? Get.back),
              SizedBox(width: 7.w),
              Text(
                'Back',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: OnboardingColors.pureBlack,
                ),
              ),
            ],
          ),
        SizedBox(height: 12.h),
        Divider(height: 1.h, thickness: 1, color: OnboardingColors.divider),
      ],
    );
  }
}

class _BackCircle extends StatelessWidget {
  const _BackCircle({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: OnboardingColors.surfaceGray,
          borderRadius: BorderRadius.circular(18.r),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          OnboardingAssets.icBack,
          width: 16.w,
          height: 16.w,
        ),
      ),
    );
  }
}
