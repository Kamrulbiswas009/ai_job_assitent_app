import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/custom_card_text_field.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/start_step2_details_controller.dart';
import '../widgets/briefing_processing_modal.dart';
import '../widgets/start_header.dart';
import '../widgets/voice_recorder_card.dart';

class StartStep2DetailsScreen extends GetView<StartStep2DetailsController> {
  const StartStep2DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure scenario UI texts are synchronized with selected goal
    controller.syncScenario();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const StartHeader(currentStep: 2, showDivider: true),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        // Selected Goal Header (Red bag icon + Dynamic Scenario Title)
                        Row(
                          children: [
                            Image.asset(
                              IconPath.icJobInterview,
                              width: 22.w,
                              height: 22.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.selectedGoalTitle.value,
                                  style: GoogleFonts.inter(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.pureBlack,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // Dynamic Subtitle tailored to the selected scenario
                        Obx(
                          () => Text(
                            controller.scenarioSubtitle.value,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: const Color(0xFF757575),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Field 1: Keywords / Goal TextField with RED BORDER (starts empty)
                        Obx(
                          () => CustomCardTextField(
                            controller: controller.interviewKeywordsController,
                            minLines: 3,
                            maxLines: 4,
                            borderRadius: 16.r,
                            borderWidth: 1.2,
                            borderColor: AppColors.primary,
                            focusedBorderColor: AppColors.primary,
                            padding: EdgeInsets.all(16.w),
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: AppColors.pureBlack,
                            ),
                            hintText: controller.keywordsHint.value,
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Field 2: Dynamic Role / Situation Question Title
                        Obx(
                          () => Text(
                            controller.roleFieldTitle.value,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Field 2: Role / Situation TextField (starts empty)
                        Obx(
                          () => CustomCardTextField(
                            controller: controller.roleApplyingController,
                            minLines: 3,
                            maxLines: 4,
                            borderRadius: 16.r,
                            borderColor: const Color(0xFFE5E5EA),
                            focusedBorderColor: AppColors.primary,
                            padding: EdgeInsets.all(16.w),
                            hintText: controller.roleFieldHint.value,
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: const Color(0xFFA0A0A8),
                            ),
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Field 3: Dynamic In Your Own Words Spoken Question
                        Obx(
                          () => Text(
                            controller.voiceQuestionTitle.value,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Speak your answer — SpeechPro will transcribe it and use it to assess how you come across',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF757575),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        // Voice Recording Card
                        Obx(
                          () => VoiceRecorderCard(
                            isRecording: controller.isRecording.value,
                            durationSeconds: controller.recordDuration.value,
                            onToggleRecord: controller.toggleRecording,
                            isCompactHorizontal: true,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Field 4: Additional Sentences / Notes TextField (starts empty)
                        Obx(
                          () => CustomCardTextField(
                            controller: controller.voiceAnswerTextController,
                            minLines: 3,
                            maxLines: 4,
                            borderRadius: 16.r,
                            borderColor: const Color(0xFFE5E5EA),
                            focusedBorderColor: AppColors.primary,
                            padding: EdgeInsets.all(16.w),
                            hintText: controller.additionalNotesHint.value,
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: const Color(0xFFA0A0A8),
                            ),
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                  child: SpPrimaryButton(
                    label: 'Continue',
                    onPressed: controller.submitDetailsAndProceed,
                  ),
                ),
              ],
            ),
            // Black Briefing Processing Modal Transition (3 sequential AI briefing steps)
            Obx(
              () => controller.isProcessingBriefing.value
                  ? BriefingProcessingModal(
                      onComplete: controller.onProcessingComplete,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
