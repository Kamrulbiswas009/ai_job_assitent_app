import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/start_calibration_controller.dart';
import '../widgets/score_calculation_modal.dart';
import '../widgets/start_header.dart';
import '../widgets/voice_recorder_card.dart';

class StartStep4CalibrationScreen extends GetView<StartCalibrationController> {
  const StartStep4CalibrationScreen({super.key});

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
                  child: const StartHeader(currentStep: 4, showDivider: true),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          'VOICE CALIBRATION',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Now I want to\nhear your voice.',
                          style: GoogleFonts.inter(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            color: AppColors.pureBlack,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Tell me about yourself — who you are, what you do, and what you are hoping to achieve with SpeechPro. Speak naturally and confidently. You have sixty seconds.',
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.45,
                            color: const Color(0xFF757575),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // Audio Timeline Track from Figma Screen 1
                        Container(
                          width: double.infinity,
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEBEF),
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 12.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7C7CC),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Voice Recorder Card with Waveform
                        Obx(
                          () => VoiceRecorderCard(
                            isRecording: controller.isRecording.value,
                            durationSeconds: controller.durationSeconds.value,
                            onToggleRecord: controller.toggleRecording,
                            label: 'Tap to speak your Answer',
                          ),
                        ),
                        SizedBox(height: 28.h),
                        // Skip Voice calibration
                        Center(
                          child: GestureDetector(
                            onTap: controller.proceedToStep5,
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              'Skip Voice calibration',
                              style: GoogleFonts.inter(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Score Calculation Modal (Screen 2 in Figma)
            Obx(
              () => controller.isCalculating.value
                  ? ScoreCalculationModal(
                      onComplete: controller.onCalculationComplete,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
