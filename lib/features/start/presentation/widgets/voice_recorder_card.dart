import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class VoiceRecorderCard extends StatelessWidget {
  final bool isRecording;
  final int durationSeconds;
  final VoidCallback onToggleRecord;
  final String label;
  final bool isCompactHorizontal; // true for Step 2, false for Step 4

  const VoiceRecorderCard({
    super.key,
    required this.isRecording,
    required this.durationSeconds,
    required this.onToggleRecord,
    this.label = 'Tap to speak your Answer',
    this.isCompactHorizontal = false,
  });

  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  // Exact 24 waveform bar heights from Figma
  static const List<double> waveformHeights = [
    27.6, 24.4, 17.1, 8.25, 17.7, 24.75, 27.7, 25.8,
    19.5, 10.4, 15.2, 23.1, 27.3, 26.8, 21.6, 13.1,
    12.5, 21.2, 26.6, 27.5, 23.5, 15.8, 9.7, 19.0
  ];

  @override
  Widget build(BuildContext context) {
    if (isCompactHorizontal) {
      return _buildCompactHorizontalLayout();
    }
    return _buildCenteredCalibrationLayout();
  }

  // Step 2 exact Figma Layout (387x145 Container)
  Widget _buildCompactHorizontalLayout() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status Tag: Red dot + Recording · 0:00
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Recording · ${_formatTime(durationSeconds)}',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            isRecording ? 'Listening...' : label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 14.h),
          // Horizontal Row: 44x44 Mic Button + Waveform Bars
          Row(
            children: [
              GestureDetector(
                onTap: onToggleRecord,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 44.r,
                  height: 44.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: isRecording ? 0.4 : 0.2),
                        blurRadius: isRecording ? 12 : 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isRecording
                      ? Icon(
                          Icons.stop_rounded,
                          color: AppColors.white,
                          size: 22.sp,
                        )
                      : SvgPicture.asset(
                          IconPath.icMic,
                          width: 22.w,
                          height: 22.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 13.w),
              // Waveform bars
              Expanded(
                child: SizedBox(
                  height: 36.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: waveformHeights.map((h) {
                      final barH = isRecording ? (h * 1.1).h : (h * 0.45).h;
                      return Container(
                        width: 3.5.w,
                        height: barH,
                        decoration: BoxDecoration(
                          color: isRecording
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Step 4 Centered Calibration Layout (Direct on screen without outer card container)
  Widget _buildCenteredCalibrationLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'Recording · ${_formatTime(durationSeconds)}',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 1.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        GestureDetector(
          onTap: onToggleRecord,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 99.r,
            height: 99.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isRecording ? 0.4 : 0.25),
                  blurRadius: isRecording ? 18 : 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isRecording
                ? Icon(
                    Icons.stop_rounded,
                    color: AppColors.white,
                    size: 44.sp,
                  )
                : SvgPicture.asset(
                    IconPath.icMic,
                    width: 54.w,
                    height: 54.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          isRecording ? 'Listening... Tap to finish' : label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: const Color(0xFF333333),
          ),
        ),
        SizedBox(height: 28.h),
        SizedBox(
          height: 48.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: waveformHeights.map((h) {
              final barH = isRecording ? (h * 1.1).h : (h * 0.7).h;
              return Container(
                width: 6.w,
                height: barH,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: isRecording
                      ? AppColors.primary
                      : AppColors.primary.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

