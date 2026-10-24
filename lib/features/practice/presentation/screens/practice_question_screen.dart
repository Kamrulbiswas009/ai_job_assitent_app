import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/common/widgets/sp_shimmer.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/practice_question_controller.dart';
import '../../model/practice_cues_guidance_model.dart';
import '../../model/practice_question_model.dart';
import '../widgets/practice_meta_chips.dart';
import '../widgets/practice_question_progress.dart';
import '../widgets/practice_scaffold.dart';

class PracticeQuestionScreen extends GetView<PracticeQuestionController> {
  const PracticeQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      isRoot: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                final data = controller.questionData.value;
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isLoading) ...[
                        SpShimmer.box(
                          width: 210.w,
                          height: 18.h,
                          borderRadius: 6.r,
                        ),
                        SizedBox(height: 9.h),
                        SpShimmer.box(
                          width: double.infinity,
                          height: 6.h,
                          borderRadius: 999.r,
                        ),
                      ] else
                        PracticeQuestionProgress(
                          label: controller.progressLabel,
                          fraction: controller.progressFraction,
                        ),
                      SizedBox(height: 18.h),
                      if (isLoading)
                        Row(
                          children: [
                            SpShimmer.box(
                              width: 110.w,
                              height: 22.h,
                              borderRadius: 999.r,
                            ),
                            SizedBox(width: 10.w),
                            SpShimmer.box(
                              width: 130.w,
                              height: 22.h,
                              borderRadius: 999.r,
                            ),
                            SizedBox(width: 10.w),
                            SpShimmer.box(
                              width: 90.w,
                              height: 22.h,
                              borderRadius: 999.r,
                            ),
                          ],
                        )
                      else
                        PracticeMetaChips(chips: data.chips),
                      SizedBox(height: 20.h),
                      if (isLoading) ...[
                        SpShimmer.box(
                          width: double.infinity,
                          height: 28.h,
                          borderRadius: 6.r,
                        ),
                        SizedBox(height: 8.h),
                        SpShimmer.box(
                          width: 180.w,
                          height: 28.h,
                          borderRadius: 6.r,
                        ),
                      ] else
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
                      if (isLoading)
                        _buildCoachReminderShimmer()
                      else
                        _buildCoachReminderCard(data),
                      SizedBox(height: 20.h),
                      if (isLoading)
                        _buildQuestionVideoShimmer()
                      else
                        _buildQuestionVideoCard(data),
                      SizedBox(height: 24.h),
                      if (isLoading)
                        _buildBeforeYouAnswerShimmer()
                      else
                        _buildBeforeYouAnswerSection(data),
                      SizedBox(height: 16.h),
                      if (isLoading)
                        _buildGuidanceCuesShimmer()
                      else
                        _buildGuidanceCues(data),
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              }),
            ),
            Obx(() => _buildBottomBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachReminderShimmer() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFBE3E1), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpShimmer.circle(size: 44.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpShimmer.box(
                  width: double.infinity,
                  height: 16.h,
                  borderRadius: 4.r,
                ),
                SizedBox(height: 8.h),
                SpShimmer.box(width: 220.w, height: 16.h, borderRadius: 4.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionVideoShimmer() {
    return Container(
      width: double.infinity,
      height: 240.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12.w,
            top: 12.h,
            child: SpShimmer.box(width: 150.w, height: 28.h, borderRadius: 6.r),
          ),
          Positioned(
            left: 18.w,
            right: 18.w,
            bottom: 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpShimmer.box(
                  width: double.infinity,
                  height: 18.h,
                  borderRadius: 4.r,
                ),
                SizedBox(height: 8.h),
                SpShimmer.box(width: 200.w, height: 18.h, borderRadius: 4.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeforeYouAnswerShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SpShimmer.box(width: 170.w, height: 16.h, borderRadius: 4.r),
        SizedBox(height: 14.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpShimmer.circle(size: 22.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpShimmer.box(
                    width: double.infinity,
                    height: 14.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 6.h),
                  SpShimmer.box(width: 180.w, height: 14.h, borderRadius: 4.r),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpShimmer.circle(size: 22.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpShimmer.box(width: 110.w, height: 16.h, borderRadius: 4.r),
                  SizedBox(height: 8.h),
                  SpShimmer.box(
                    width: double.infinity,
                    height: 14.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 6.h),
                  SpShimmer.box(width: 210.w, height: 14.h, borderRadius: 4.r),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuidanceCuesShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: index == 2 ? 0 : 10.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
          ),
          child: Row(
            children: [
              SpShimmer.circle(size: 22.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpShimmer.box(width: 140.w, height: 16.h, borderRadius: 4.r),
                    SizedBox(height: 6.h),
                    SpShimmer.box(
                      width: double.infinity,
                      height: 13.h,
                      borderRadius: 4.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCoachReminderCard(PracticeQuestionModel data) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFBE3E1), width: 1),
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
            child: Text(
              [
                data.coachContext.trim(),
                data.countsTag.trim(),
              ].where((part) => part.isNotEmpty).join(' '),
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF555555),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionVideoCard(PracticeQuestionModel data) {
    final thumbnailUrl = data.thumbnailUrl;

    return Container(
      width: double.infinity,
      height: 240.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: thumbnailUrl != null && thumbnailUrl.isNotEmpty
              ? NetworkImage(thumbnailUrl)
              : const AssetImage(ImagePath.spVideoThumb) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
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
                data.speakerRole,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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

  Widget _buildBeforeYouAnswerSection(PracticeQuestionModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BEFORE YOU ANSWER',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 14.h),
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
        SizedBox(height: 16.h),
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

  Widget _buildGuidanceCues(PracticeQuestionModel data) {
    return Column(
      children: List.generate(data.cues.length, (index) {
        final cue = data.cues[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index == data.cues.length - 1 ? 0 : 10.h),
          child: _buildCueCard(cue, index),
        );
      }),
    );
  }

  Widget _buildCueCard(PracticePillarCueModel cue, int index) {
    return GestureDetector(
      onTap: () => controller.openGuidance(cueIndex: index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
        ),
        child: Row(
          children: [
            _cueIcon(cue.iconKey),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cue.title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0A0A0A),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    cue.question,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF666666),
                      height: 1.35,
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

  Widget _cueIcon(String key) {
    const color = ColorFilter.mode(AppColors.primary, BlendMode.srcIn);
    switch (key) {
      case 'sound':
        return SvgPicture.asset(
          IconPath.spSound,
          width: 22.r,
          height: 22.r,
          colorFilter: color,
        );
      case 'clock':
        return Icon(
          Icons.schedule_rounded,
          size: 22.r,
          color: AppColors.primary,
        );
      case 'chat':
        return SvgPicture.asset(
          IconPath.spUser,
          width: 22.r,
          height: 22.r,
          colorFilter: color,
        );
      case 'heart':
        return SvgPicture.asset(
          IconPath.spHeart,
          width: 22.r,
          height: 22.r,
          colorFilter: color,
        );
      case 'target':
      default:
        return SvgPicture.asset(
          IconPath.spTarget,
          width: 22.r,
          height: 22.r,
          colorFilter: color,
        );
    }
  }

  Widget _buildBottomBar() {
    final isLoading = controller.isLoading.value;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5EA), width: 0.8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            SpShimmer.box(
              width: double.infinity,
              height: 54.h,
              borderRadius: 999.r,
            ),
            SizedBox(height: 12.h),
            SpShimmer.box(width: 170.w, height: 16.h, borderRadius: 4.r),
          ] else ...[
          SpPrimaryButton(
            label: controller.questionData.value.tapToRecordLabel,
            onPressed: controller.openAnswerRecord,
            height: 54.h,
            borderRadius: 999.r,
            textStyle: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            prefixIcon: SvgPicture.asset(
              IconPath.spMicSvg,
              width: 18.r,
              height: 18.r,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 8.h),
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
                    controller.questionData.value.hearQuestionAgainLabel,
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
        ],
      ),
    );
  }
}
