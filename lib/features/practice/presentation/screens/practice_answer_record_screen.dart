import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../start/presentation/widgets/voice_recorder_card.dart';
import '../../controller/practice_answer_record_controller.dart';
import '../../controller/practice_question_controller.dart';
import '../widgets/practice_meta_chips.dart';
import '../widgets/practice_scaffold.dart';

class PracticeAnswerRecordScreen
    extends GetView<PracticeAnswerRecordController> {
  const PracticeAnswerRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final question = Get.isRegistered<PracticeQuestionController>()
        ? Get.find<PracticeQuestionController>().questionData.value
        : null;

    return PracticeScaffold(
      isRoot: false,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECORD YOUR ANSWER',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Now I want to\nhear your voice.',
                style: GoogleFonts.inter(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: AppColors.pureBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                question?.questionText.isNotEmpty == true
                    ? question!.questionText
                    : 'Speak naturally and confidently. You have sixty seconds.',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  color: const Color(0xFF757575),
                ),
              ),
              if (question != null) ...[
                SizedBox(height: 16.h),
                PracticeMetaChips(chips: question.chips),
              ],
              SizedBox(height: 18.h),
              Obx(() {
                final progress =
                    (controller.durationSeconds.value / 60.0).clamp(0.0, 1.0);
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final trackWidth =
                        (12.w + (constraints.maxWidth - 12.w) * progress)
                            .clamp(12.w, constraints.maxWidth);
                    return Container(
                      width: double.infinity,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEBEF),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: trackWidth,
                        height: 3.h,
                        decoration: BoxDecoration(
                          color: controller.isRecording.value
                              ? AppColors.primary
                              : const Color(0xFFC7C7CC),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 28.h),
              Obx(
                () => VoiceRecorderCard(
                  isRecording: controller.isRecording.value,
                  durationSeconds: controller.durationSeconds.value,
                  onToggleRecord: controller.toggleRecording,
                  volumeLevel: controller.currentVolume.value,
                  isVoiceDetected: controller.isVoiceDetected.value,
                  label: 'Tap to speak your Answer',
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Text(
                  'Tap the mic to finish, then hear your recording.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              _buildDemoVoiceOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDemoVoiceOption() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEBEBEF)),
      ),
      child: Column(
        children: [
          Text(
            'UNDER DEVELOPMENT',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF8E8E93),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'No working microphone? Each question has its own bundled sample answer so you can walk the full 3-question flow.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: const Color(0xFF666666),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton(
                onPressed: controller.isUsingDemo.value
                    ? null
                    : controller.useDemoVoice,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                child: Text(
                  controller.isUsingDemo.value
                      ? 'Loading demo voice…'
                      : controller.demoVoiceButtonLabel,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
