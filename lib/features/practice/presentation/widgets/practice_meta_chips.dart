import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/icon_path.dart';

class PracticeMetaChips extends StatelessWidget {
  final List<String> chips;

  const PracticeMetaChips({
    super.key,
    required this.chips,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: chips.asMap().entries.map((entry) {
          final idx = entry.key;
          final chip = entry.value;

          Widget iconWidget;
          if (idx == 0) {
            iconWidget = SvgPicture.asset(
              IconPath.spBook,
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                Color(0xFF666666),
                BlendMode.srcIn,
              ),
            );
          } else if (idx == 1) {
            iconWidget = SvgPicture.asset(
              IconPath.spUser,
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                Color(0xFF666666),
                BlendMode.srcIn,
              ),
            );
          } else {
            iconWidget = SvgPicture.asset(
              IconPath.spFlash,
              width: 16.r,
              height: 16.r,
              colorFilter: const ColorFilter.mode(
                Color(0xFF666666),
                BlendMode.srcIn,
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconWidget,
                SizedBox(width: 4.w),
                Text(
                  chip,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

