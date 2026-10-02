import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';

class GoalItemTile extends StatelessWidget {
  final String number;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const GoalItemTile({
    super.key,
    required this.number,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50.h,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E5EA),
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Number Box
            Container(
              width: 26.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(4.r),
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? AppColors.white : const Color(0xFF888888),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  height: 1.3,
                  color: AppColors.pureBlack,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, color: AppColors.primary, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
