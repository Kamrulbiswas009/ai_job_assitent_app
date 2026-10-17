import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';

class PracticeQuestionProgress extends StatelessWidget {
  final String label;
  final double fraction;

  const PracticeQuestionProgress({
    super.key,
    required this.label,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = fraction.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 9.h),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 6.h,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEEEF),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  height: 6.h,
                  width: constraints.maxWidth * clamped,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
