import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/practice_session_complete_controller.dart';

class PracticeSessionCompleteScreen
    extends GetView<PracticeSessionCompleteController> {
  const PracticeSessionCompleteScreen({super.key});

  static const _journey = [
    'Setup',
    'Brief',
    'Warm-up',
    'Practice',
    'Debrief',
    'Summary',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          final data = controller.data.value;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 8.h),
                child: Image.asset(
                  ImagePath.spHeaderLogo,
                  height: 42.h,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
                  child: Column(
                    children: [
                      _buildJourneyBar(),
                      SizedBox(height: 22.h),
                      Text(
                        data.sessionTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          color: AppColors.pureBlack,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        data.contextLine,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF888888),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18.r),
                        child: AspectRatio(
                          aspectRatio: 3 / 3.4,
                          child: Image.asset(
                            ImagePath.spHiFive,
                            fit: BoxFit.cover,
                            alignment: const Alignment(0, -0.15),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 20.h),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Column(
                          children: [
                            Text(
                              data.encouragementTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                                color: AppColors.pureBlack,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.45,
                                  color: const Color(0xFF555555),
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'In a short space of time, you’ve already ',
                                  ),
                                  TextSpan(
                                    text: 'begun to turn instinct into technique.',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const TextSpan(
                                    text:
                                        ' Every time you practise with intention, your voice becomes clearer, calmer and more authoritative.',
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 22.h),
                      GestureDetector(
                        onTap: controller.continueToProgression,
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 28.r,
                              color: const Color(0xFF888888),
                            ),
                            Text(
                              'Scroll to continue',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildJourneyBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < _journey.length; i++) ...[
            _JourneyStep(
              label: _journey[i],
              isCurrent: i == _journey.length - 1,
              isDone: i < _journey.length - 1,
            ),
            if (i < _journey.length - 1)
              Container(
                width: 18.w,
                height: 1.5,
                margin: EdgeInsets.only(bottom: 14.h),
                color: const Color(0xFFD8D8DE),
              ),
          ],
        ],
      ),
    );
  }
}

class _JourneyStep extends StatelessWidget {
  final String label;
  final bool isCurrent;
  final bool isDone;

  const _JourneyStep({
    required this.label,
    required this.isCurrent,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final Color dot;
    if (isCurrent) {
      dot = AppColors.primary;
    } else if (isDone) {
      dot = const Color(0xFFC7C7CC);
    } else {
      dot = const Color(0xFFE5E5EA);
    }

    return Column(
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            color: dot,
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: AppColors.primaryTint, width: 3)
                : null,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? AppColors.primary : const Color(0xFF8E8E93),
          ),
        ),
      ],
    );
  }
}
