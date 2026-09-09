import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';

class StartHeader extends StatelessWidget {
  final int? currentStep; // 1 to 5
  final VoidCallback? onBack;
  final bool showLogo;

  const StartHeader({
    super.key,
    this.currentStep,
    this.onBack,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back Button Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBack ?? () => Get.back(),
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      size: 16.sp,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        const Divider(height: 1, thickness: 1, color: Color(0x14000000)),
        if (showLogo) ...[
          SizedBox(height: 16.h),
          Center(
            child: Image.asset(
              ImagePath.logoHeader,
              width: 333.w,
              height: 96.h,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 12.h),
        ],
        if (currentStep != null) ...[
          SizedBox(height: 8.h),
          // 5-Segment Progress Bar
          Row(
            children: List.generate(5, (index) {
              final isPassed = index < currentStep!;
              return Expanded(
                child: Container(
                  height: 4.h,
                  margin: EdgeInsets.only(right: index < 4 ? 6.w : 0),
                  decoration: BoxDecoration(
                    color: isPassed ? AppColors.primary : const Color(0xFFE5E5EA),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 10.h),
          Text(
            'Step $currentStep of 5',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: AppColors.primary,
            ),
          ),
        ],
      ],
    );
  }
}
