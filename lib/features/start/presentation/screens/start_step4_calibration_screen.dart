import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/start_controller.dart';
import '../widgets/start_header.dart';
import '../widgets/voice_recorder_card.dart';

class StartStep4CalibrationScreen extends GetView<StartController> {
  const StartStep4CalibrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(currentStep: 4),
            ),
            Expanded(
              child: SingleChildScrollView(
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
                    SizedBox(height: 4.h),
                    Text(
                      'Now I want to\nhear your voice.',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tell me about yourself — who you are, what you do, and what you are hoping to achieve with SpeechPro. Speak naturally and confidently. You have sixty seconds.',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Voice Recorder
                    Obx(
                      () => VoiceRecorderCard(
                        isRecording: controller.isCalibrationRecording.value,
                        durationSeconds: controller.calibrationDuration.value,
                        onToggleRecord: controller.toggleCalibrationRecording,
                        label: 'Tap to speak your Answer',
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Skip Voice calibration
                    Center(
                      child: GestureDetector(
                        onTap: controller.goToStep5,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          'Skip Voice calibration',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SpPrimaryButton(
                label: 'Continue',
                onPressed: controller.goToStep5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
