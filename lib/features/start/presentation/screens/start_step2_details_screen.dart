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
                    // Selected Goal Header (Red bag icon + Title)
                    Row(
                      children: [
                        Image.asset(
                          IconPath.icJobInterview,
                          width: 22.w,
                          height: 22.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Job Interview',
                          style: GoogleFonts.inter(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pureBlack,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tell SpeechPro about your interview. Add a few keywords below about why you want to win this job.',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                        color: Color(0xFF757575),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Field 1: Keywords Single TextField with RED BORDER
                    CustomCardTextField(
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
                        color: const Color(0xFF6B7280),
                      ),
                      hintText:
                          'I have a job interview coming up and I want to walk in with complete authority and conviction.',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Field 2: Role applying for
                    Text(
                      'What role are you applying for?',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    CustomCardTextField(
                      controller: controller.roleApplyingController,
                      minLines: 3,
                      maxLines: 4,
                      borderRadius: 16.r,
                      borderColor: const Color(0xFFE5E5EA),
                      focusedBorderColor: AppColors.primary,
                      padding: EdgeInsets.all(16.w),
                      hintText: 'e.g. Head of Marketing at Unilever',
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
                    SizedBox(height: 24.h),
                    // Field 3: In your own words question
                    Text(
                      'In your own words — why do you want this role and why are you the right person for it?',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: AppColors.pureBlack,
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
                    // Field 4: Additional Sentences Single TextField
                    CustomCardTextField(
                      controller: controller.voiceAnswerTextController,
                      minLines: 3,
                      maxLines: 4,
                      borderRadius: 16.r,
                      borderColor: const Color(0xFFE5E5EA),
                      focusedBorderColor: AppColors.primary,
                      padding: EdgeInsets.all(16.w),
                      hintText:
                          'use thr text below to add a few additional sentences why you feel you are the best person to win this',
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
        // Black Briefing Processing Modal Transition (No score, 3 sequential AI briefing steps)
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
