import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/practice_cues_guidance_controller.dart';
import '../../controller/practice_question_controller.dart';
import '../widgets/practice_meta_chips.dart';
import '../widgets/practice_question_progress.dart';
import '../widgets/practice_scaffold.dart';

class PracticeCuesGuidanceScreen
    extends GetView<PracticeCuesGuidanceController> {
  const PracticeCuesGuidanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.guidanceData.value;

    return PracticeScaffold(
      isRoot: false,
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
                    PracticeQuestionProgress(
                      label: Get.isRegistered<PracticeQuestionController>()
                          ? Get.find<PracticeQuestionController>().progressLabel
                          : data.stepTag,
                      fraction: Get.isRegistered<PracticeQuestionController>()
                          ? Get.find<PracticeQuestionController>()
                              .progressFraction
                          : 1 / 3,
                    ),
                    SizedBox(height: 18.h),

                    // Chips Row: Document + Profile + Flash
                    PracticeMetaChips(chips: data.chips),
                    SizedBox(height: 24.h),

                    // 5 Pillar Cues: Container pad L12 R12 T12 B12, Radius 12, ItemSp 8
                    Obx(() {
                      final selectedIdx = controller.selectedCueIndex.value;
                      return Column(
                        children: List.generate(data.cues.length, (index) {
                          final cue = data.cues[index];
                          final isSelected = index == selectedIdx;

                          return GestureDetector(
                            onTap: () => controller.selectCue(index),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFDF5F6)
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : const Color(0xFFECEEF0),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.r,
                                    height: 40.r,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.primarySoft,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: _getCueIconWidget(
                                      cue.iconKey,
                                      isSelected,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cue.title,
                                          style: GoogleFonts.inter(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0A0A0A),
                                            height: 1.3,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          cue.question,
                                          style: GoogleFonts.inter(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF666666),
                                            height: 1.4,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    IconPath.spArrowRight,
                                    width: 16.r,
                                    height: 16.r,
                                    colorFilter: ColorFilter.mode(
                                      isSelected
                                          ? AppColors.primary
                                          : const Color(0xFF8E8E93),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                    SizedBox(height: 20.h),
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

  Widget _getCueIconWidget(String key, bool isSelected) {
    final color = isSelected ? Colors.white : AppColors.primary;
    switch (key) {
      case 'sound':
        return SvgPicture.asset(
          IconPath.spSound,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      case 'clock':
        return SvgPicture.asset(
          IconPath.spSound,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      case 'chat':
        return SvgPicture.asset(
          IconPath.spUser,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      case 'heart':
        return SvgPicture.asset(
          IconPath.spHeart,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
      case 'target':
      default:
        return SvgPicture.asset(
          IconPath.spTarget,
          width: 20.r,
          height: 20.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        );
    }
  }
}
