import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/practice_coach_feedback_controller.dart';
import '../widgets/local_voice_player.dart';
import '../widgets/practice_scaffold.dart';

class PracticeCoachFeedbackScreen
    extends GetView<PracticeCoachFeedbackController> {
  const PracticeCoachFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      isRoot: false,
      body: SafeArea(
        top: false,
        child: Obx(() {
          final data = controller.feedback.value;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COACH FEEDBACK · QUESTION ${data.questionIndex}',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: const Color(0xFF888888),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      _buildYouSaidCard(data.youSaid, data.durationLabel),
                      SizedBox(height: 12.h),
                      _buildLandedCard(data.whatLanded),
                      SizedBox(height: 12.h),
                      _buildNextAnswerCard(data.nextAnswerTip),
                      if (data.audioPath.isNotEmpty)
                        LocalVoicePlayer(
                          filePath: data.audioPath,
                          isPlaying: controller.isPlayingFeedback.value,
                          onCompleted: controller.onPlaybackCompleted,
                        ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(data.hasNextQuestion, data.nextQuestionIndex),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildYouSaidCard(String quote, String duration) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBadge(
                icon: Icons.format_quote_rounded,
                background: AppColors.primaryTint,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'YOU SAID',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            '"$quote"',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: const Color(0xFF444444),
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              duration,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF888888),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandedCard(String body) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF8F1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBadge(
                icon: Icons.check_rounded,
                background: const Color(0xFFD8F3E0),
                color: const Color(0xFF1F9D4A),
              ),
              SizedBox(width: 8.w),
              Text(
                'WHAT LANDED',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: const Color(0xFF1F9D4A),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: const Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAnswerCard(String body) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconBadge(
                icon: Icons.lightbulb_outline_rounded,
                background: const Color(0xFFFFE7C2),
                color: const Color(0xFFE09100),
              ),
              SizedBox(width: 8.w),
              Text(
                'FOR YOUR NEXT ANSWER',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  color: const Color(0xFFE09100),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            body,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: const Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBadge({
    required IconData icon,
    required Color background,
    required Color color,
  }) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Icon(icon, size: 16.r, color: color),
    );
  }

  Widget _buildBottomBar(bool hasNext, int nextIndex) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: OutlinedButton(
              onPressed: controller.toggleHearFeedback,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: Color(0xFFE5E5EA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
              child: Obx(() {
                final playing = controller.isPlayingFeedback.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 22.r,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      playing ? 'Playing feedback…' : 'Hear feedback',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 12.h),
          SpPrimaryButton(
            label: hasNext
                ? 'Continue to Question $nextIndex  →'
                : 'Finish practice  →',
            onPressed: controller.continueToNextQuestion,
            height: 54.h,
            borderRadius: 999.r,
          ),
        ],
      ),
    );
  }
}
