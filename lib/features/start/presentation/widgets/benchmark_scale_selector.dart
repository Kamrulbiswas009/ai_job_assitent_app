import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';

class BenchmarkScaleSelector extends StatelessWidget {
  final String question;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  const BenchmarkScaleSelector({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelected,
  });

  static const List<String> options = [
    'Rarely',
    'Sometimes',
    'Often',
    'Usually',
    'Always',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        // Row 1: Rarely, Sometimes, Often
        Row(
          children: [
            Expanded(child: _buildOptionPill(0, options[0])),
            SizedBox(width: 8.w),
            Expanded(child: _buildOptionPill(1, options[1])),
            SizedBox(width: 8.w),
            Expanded(child: _buildOptionPill(2, options[2])),
          ],
        ),
        SizedBox(height: 8.h),
        // Row 2: Usually, Always
        Row(
          children: [
            Expanded(child: _buildOptionPill(3, options[3])),
            SizedBox(width: 8.w),
            Expanded(child: _buildOptionPill(4, options[4])),
            SizedBox(width: 8.w),
            const Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionPill(int index, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFD1D1D6),
            width: 1.0,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            height: 1.5,
            color: isSelected ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
