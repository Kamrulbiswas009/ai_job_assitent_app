import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/practice_question_controller.dart';
import '../widgets/practice_app_bar.dart';
import '../widgets/practice_meta_chips.dart';

class PracticeQuestionScreen extends GetView<PracticeQuestionController> {
  const PracticeQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.questionData.value;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PracticeAppBar(isRoot: false),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step Progress Tag: Inter 500, Size 16, Color #666666
                    Text(
                      data.stepTag,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    SizedBox(height: 9.h),

                    // Progress Bar: Continuous Capsule Track with 1/3 Fill
                    Stack(
                      children: [
                        Container(
                          height: 6.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFEEEF),
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1 / 3,
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Chips Row: Document + Profile + Flash
                    PracticeMetaChips(chips: data.chips),
                    SizedBox(height: 24.h),

                    // Headline: Inter 700, Size 28, Color #0A0A0A, LetterSpacing -0.5
                    Text(
                      data.headline,
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A0A0A),
                        height: 1.3,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Coach Reminder Card: Pad L16 R16 T16 B16, Radius 12, Bg #FDF5F6
                    _buildCoachReminderCard(data),
                    SizedBox(height: 24.h),

                    // Video Card with Question Overlay & Exact Figma Thumbnail
                    _buildQuestionVideoCard(data),
                    SizedBox(height: 24.h),

                    // Before You Answer Section: Exact Book & Target Icons & Typography
                    _buildBeforeYouAnswerSection(data),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Area: Capsule Pill Button & Replay Link
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E5EA), width: 0.8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(() {
                    final isRec = controller.isRecording.value;
                    final duration = controller.formattedDuration;

                    return SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: controller.toggleRecording,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              IconPath.spMicSvg,
                              width: 18.r,
                              height: 18.r,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              isRec
                                  ? 'Stop Recording ($duration)'
                                  : 'Tap to record',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: controller.replayQuestion,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            IconPath.spSound,
                            width: 16.r,
                            height: 16.r,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Hear question again',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachReminderCard(dynamic data) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFFBE3E1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(999.r),
            child: Image.asset(
              ImagePath.spRoleplayWoman,
              width: 44.r,
              height: 44.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.coachContext,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF555555),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  data.countsTag,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionVideoCard(dynamic data) {
    return Container(
      width: double.infinity,
      height: 240.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        image: const DecorationImage(
          image: AssetImage(ImagePath.spVideoThumb),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Top Speaker Badge: Pad L10 R10 T6 B6, Radius 6, Bg #CC0000
          Positioned(
            left: 12.w,
            top: 12.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '${data.speakerRole} ${data.videoDuration}',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFD7D7D7),
                ),
              ),
            ),
          ),

          // Bottom Question Overlay Banner: Pad L18 R18 T16 B16, Bg #040404 with Opacity 0.6
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0x99040404),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12.r),
                ),
              ),
              child: Text(
                data.questionText,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE8E8E8),
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeforeYouAnswerSection(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BEFORE YOU ANSWER',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000000),
              ),
            ),
            GestureDetector(
              onTap: controller.openGuidance,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Text(
                    'Open Guidance',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  SvgPicture.asset(
                    IconPath.spArrowRight,
                    width: 14.r,
                    height: 14.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Support tip row with exact Book icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              IconPath.spBook,
              width: 22.r,
              height: 22.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                data.supportTip,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF555555),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Your move row with exact Target icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              IconPath.spTarget,
              width: 22.r,
              height: 22.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR MOVE',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    data.yourMove,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF555555),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
