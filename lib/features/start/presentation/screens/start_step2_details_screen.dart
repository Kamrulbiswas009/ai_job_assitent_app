import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/custom_card_text_field.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/start_controller.dart';
import '../widgets/start_header.dart';
import '../widgets/voice_recorder_card.dart';

class StartStep2DetailsScreen extends GetView<StartController> {
  const StartStep2DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(currentStep: 2),
            ),
            Expanded(
              child: SingleChildScrollView(
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
                          width: 24.w,
                          height: 24.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8.w),
                        Obx(
                          () => Text(
                            controller.selectedGoalTitle.value,
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Tell SpeechPro about your interview. Add a few keywords below about why you want to win this job.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Field 1: Keywords Single TextField with RED BORDER
                    CustomCardTextField(
                      controller: controller.interviewKeywordsController,
                      minLines: 3,
                      maxLines: 4,
                      borderRadius: 16.r,
                      borderColor: AppColors.primary,
                      focusedBorderColor: AppColors.primary,
                      padding: EdgeInsets.all(16.w),
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF757575),
                      ),
                      hintText: 'Add a few keywords...',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Field 2: Role applying for
                    Text(
                      'What role are you applying for?',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 14.h),
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
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Field 3: In your own words question
                    Text(
                      'In your own words — why do you want this role and why are you the right person for it?',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Speak your answer — SpeechPro will transcribe it and use it to assess how you come across',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    // Voice Recording Card
                    Obx(
                      () => VoiceRecorderCard(
                        isRecording: controller.isStep2Recording.value,
                        durationSeconds: controller.step2RecordDuration.value,
                        onToggleRecord: controller.toggleStep2Recording,
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
                          'use the text below to add a few additional sentences why you feel you are the best person to win this',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SpPrimaryButton(
                label: 'Continue',
                onPressed: controller.goToBriefing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
