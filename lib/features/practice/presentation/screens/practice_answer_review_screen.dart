import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/practice_answer_review_controller.dart';
import '../../controller/practice_question_controller.dart';
import '../widgets/local_voice_player.dart';
import '../widgets/practice_meta_chips.dart';
import '../widgets/practice_question_progress.dart';
import '../widgets/practice_scaffold.dart';

class PracticeAnswerReviewScreen
    extends GetView<PracticeAnswerReviewController> {
  const PracticeAnswerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final question = Get.isRegistered<PracticeQuestionController>()
        ? Get.find<PracticeQuestionController>().questionData.value
        : null;

    return PracticeScaffold(
      isRoot: false,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PracticeQuestionProgress(
                      label: Get.isRegistered<PracticeQuestionController>()
                          ? Get.find<PracticeQuestionController>().progressLabel
                          : question?.stepTag ?? 'PRACTICE · QUESTION 1 OF 3',
                      fraction: Get.isRegistered<PracticeQuestionController>()
                          ? Get.find<PracticeQuestionController>()
                              .progressFraction
                          : question?.progressFraction ?? 1 / 3,
                    ),
                    SizedBox(height: 18.h),
                    if (question != null) PracticeMetaChips(chips: question.chips),
                    SizedBox(height: 24.h),
                    _buildPlaybackCard(),
                    Obx(() {
                      final path = controller.audioPath.value;
                      if (path.isEmpty) return const SizedBox.shrink();
                      return LocalVoicePlayer(
                        filePath: path,
                        isPlaying: controller.isPlaying.value,
                        onCompleted: controller.onPlaybackCompleted,
                      );
                    }),
                  ],
                ),
              ),
            ),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackCard() {
    return Obx(() {
      final isPlaying = controller.isPlaying.value;
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF5F6),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFFBE3E1), width: 1),
        ),
        child: Column(
          children: [
            Text(
              'YOUR RECORDED ANSWER',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: controller.togglePlayback,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 88.r,
                height: 88.r,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 44.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              isPlaying ? 'Playing your recording' : 'Tap to hear your voice',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0A0A0A),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              controller.formattedPlaybackDuration,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E5EA), width: 0.8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: OutlinedButton(
              onPressed: controller.recordAgain,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0A0A0A),
                side: const BorderSide(color: Color(0xFFE5E5EA), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              child: Text(
                'Record again',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0A0A0A),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => SpPrimaryButton(
              label: 'Submit answer  →',
              onPressed: controller.submitAnswer,
              isLoading: controller.isSubmitting.value,
              height: 54.h,
              borderRadius: 999.r,
            ),
          ),
        ],
      ),
    );
  }
}
