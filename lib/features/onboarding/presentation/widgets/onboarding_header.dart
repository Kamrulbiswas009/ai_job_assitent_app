import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';

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
        SizedBox(height: 10.h),
        SizedBox(
          height: 44.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onBack ?? Get.back,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceGray,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    IconPath.icBack,
                    width: 22.w,
                    height: 22.w,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              if (style == OnboardingHeaderStyle.logo)
                Image.asset(
                  ImagePath.logoHeader,
                  height: 40.h,
                  fit: BoxFit.contain,
                )
              else
                Text(
                  'Back',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: AppColors.pureBlack,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Divider(height: 1.h, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
