import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/practice_warmup_controller.dart';
import '../widgets/local_voice_player.dart';
import '../widgets/practice_scaffold.dart';

class PracticeWarmupScreen extends GetView<PracticeWarmupController> {
  const PracticeWarmupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      isRoot: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final data = controller.warmupData.value;
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      data.badge,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE60008),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Title: Inter 700, Size 28, Color #0A0A0A, LetterSpacing -0.5
                    Text(
                      data.title,
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A0A0A),
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Subtitle: Inter 400, Size 16, Color #666666
                    Text(
                      data.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Alert Notice Box: Figma Pad L16 R16 T16 B16, Radius 12, Bg #FDF5F6
                    Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF5F6),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFFBE3E1),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            IconPath.spAlert,
                            width: 24.r,
                            height: 24.r,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.alertTitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFE60008),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  data.alertDescription,
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF555555),
                                    letterSpacing: -0.5,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Practice Cue Box: Figma Pad L16 R16 T16 B16, Radius 12, Bg #FDF5F6
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF5F6),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFFBE3E1),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.promptCategory,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFCC0000),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            data.promptQuestion,
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0A0A0A),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Recording Area Box: Figma Pad T24 B24, Radius 12, Bg #FBF9F9
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF9F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Obx(() {
                        final isRec = controller.isRecording.value;
                        final duration = controller.formattedDuration;

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: controller.toggleRecording,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 64.r,
                                height: 64.r,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCC0000),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFCC0000)
                                          .withValues(alpha: isRec ? 0.45 : 0.25),
                                      blurRadius: isRec ? 20 : 10,
                                      spreadRadius: isRec ? 6 : 2,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: isRec
                                    ? Icon(
                                        Icons.stop_rounded,
                                        size: 32.sp,
                                        color: Colors.white,
                                      )
                                    : SvgPicture.asset(
                                        IconPath.spMicSvg,
                                        width: 32.r,
                                        height: 32.r,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              isRec ? 'Recording · $duration' : 'Tap to record',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: isRec
                                    ? const Color(0xFFCC0000)
                                    : const Color(0xFF555555),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                    Obx(() {
                      if (!controller.hasRecording.value) {
                        return SizedBox(height: 30.h);
                      }

                      final isPlaying = controller.isPlayingBack.value;
                      return Column(
                        children: [
                          SizedBox(height: 16.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF5F6),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: const Color(0xFFFBE3E1),
                                width: 1.2,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightContainer,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Text(
                                    'Recording saved — tap play to hear yourself.',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1F9D4A),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'HEAR YOUR VOICE',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFCC0000),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                GestureDetector(
                                  onTap: controller.togglePlayback,
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 56.r,
                                    height: 56.r,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFCC0000),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 32.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                LocalVoicePlayer(
                                  filePath: controller.recordedAudioPath.value,
                                  isPlaying: isPlaying,
                                  onCompleted: controller.onPlaybackCompleted,
                                ),
                                Text(
                                  isPlaying
                                      ? 'Playing your recording…'
                                      : 'Tap to hear what you recorded',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF555555),
                                    letterSpacing: -0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 14.h),
                                TextButton(
                                  onPressed: controller.recordAgain,
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Record again',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFCC0000),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      );
                    }),
                  ],
                ),
                );
              }),
            ),

            // Bottom Continue Button if warm-up completed
            Obx(() {
              if (!controller.hasCompletedWarmup.value) {
                return const SizedBox.shrink();
              }
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE5E5EA), width: 0.8),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: SpPrimaryButton(
                      label: 'Continue to Question 1',
                      onPressed: controller.onProceedToQuestion,
                      height: 56.h,
                      borderRadius: 16.r,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
