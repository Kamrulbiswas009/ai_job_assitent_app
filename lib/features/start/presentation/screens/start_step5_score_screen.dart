import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/start_score_controller.dart';
import '../widgets/start_header.dart';

class StartStep5ScoreScreen extends GetView<StartScoreController> {
  const StartStep5ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(currentStep: 5, showDivider: true),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Your Starting Influence Score',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Score 59 / 100 Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Obx(
                          () => Text(
                            '${controller.startingInfluenceScore.value}',
                            style: GoogleFonts.inter(
                              fontSize: 60.sp,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '/100',
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: const Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Developing',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Progress Bar Meter
                    Container(
                      width: double.infinity,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5EA),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: 0.59,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Dimension Breakdown Card (Screen 3 in Figma)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9FB),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFEAEAEA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dimension Breakdown',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _buildDimensionRow('Confidence', 52),
                          SizedBox(height: 10.h),
                          _buildDimensionRow('Presence', 61),
                          SizedBox(height: 10.h),
                          _buildDimensionRow('Authority', 48),
                          SizedBox(height: 10.h),
                          _buildDimensionRow('Leadership', 55),
                          SizedBox(height: 10.h),
                          _buildDimensionRow('Persuasion', 59),
                          SizedBox(height: 10.h),
                          _buildDimensionRow('Communication', 63),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Instinct Callout Card with Left Red Border
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9F9FB),
                          border: Border(
                            left: BorderSide(
                              color: AppColors.primary,
                              width: 4.0,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'There is real instinct here.',
                              style: GoogleFonts.inter(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.pureBlack,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'But instinct is not yet technique. You can feel what you want to say, but under pressure it is not landing with enough structure, authority or control. That gap is exactly what this system is built to close.',
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                                color: const Color(0xFF3A3A3C),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'SpeechPro turns raw communication instinct into repeatable command.',
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                                color: const Color(0xFF3A3A3C),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Your first session starts now',
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.45,
                                color: const Color(0xFF3A3A3C),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Training Path Card Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F9FB),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFEAEAEA)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 26.r,
                                height: 26.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Icon(
                                  Icons.bolt_rounded,
                                  size: 16.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'YOUR TRAINING PATH',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.pureBlack,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "We've built your first training path around what you told us.",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _buildPathRow('PILLAR', 'Power Through Speech'),
                          SizedBox(height: 10.h),
                          _buildPathRow('FOCUS 1', 'The Voice of Authority.'),
                          SizedBox(height: 10.h),
                          _buildPathRow('FOCUS 2', 'Yi — The Power of Intent'),
                          SizedBox(height: 14.h),
                          Text(
                            "You'll discover why these matter as you train.",
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpPrimaryButton(
                    label: 'Start My First Session',
                    onPressed: controller.finishOnboarding,
                  ),
                  SizedBox(height: 14.h),
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hear why SpeechPro is different',
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.pureBlack,
                              color: AppColors.pureBlack,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Image.asset(
                            IconPath.icPlayRedCircle,
                            width: 20.r,
                            height: 20.r,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionRow(String name, int score) {
    return Row(
      children: [
        SizedBox(
          width: 105.w,
          child: Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2C2C2E),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E5EA),
              borderRadius: BorderRadius.circular(3.r),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (score / 100).clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 24.w,
          child: Text(
            '$score',
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C2C2E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPathRow(String tag, String title) {
    return Row(
      children: [
        Icon(
          Icons.chevron_right_rounded,
          size: 14.sp,
          color: const Color(0xFF8E8E93),
        ),
        SizedBox(width: 4.w),
        Text(
          tag,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8E8E93),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
