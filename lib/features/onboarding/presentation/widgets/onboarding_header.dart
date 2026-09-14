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
    this.showBackButton = true,
    this.showDivider = false,
    this.onBack,
  });

  final OnboardingHeaderStyle style;
  final bool showBackButton;
  final bool showDivider;
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
              if (showBackButton) ...[
                GestureDetector(
                  onTap: onBack ?? Get.back,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F2F7),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      IconPath.icBack,
                      width: 16.w,
                      height: 16.w,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              if (style == OnboardingHeaderStyle.logo)
                Image.asset(
                  ImagePath.logoHeader,
                  height: 38.h,
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
        if (showDivider) ...[
          SizedBox(height: 6.h),
          Divider(height: 1.h, thickness: 1, color: AppColors.divider),
        ],
      ],
    );
  }
}
