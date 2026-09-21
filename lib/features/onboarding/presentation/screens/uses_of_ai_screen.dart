import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class UsesOfAiScreen extends StatelessWidget {
  const UsesOfAiScreen({super.key});

  static const String routeName = '/uses-of-ai';

  static const _services = [
    (
      title: 'Anthropic Claude',
      receives:
          'Your scenario context, situation details, self-assessment, and session transcripts.',
      usedFor:
          'Generating your personalised coaching briefings, questions, feedback, scoring, and debrief.',
    ),
    (
      title: 'Deepgram Nova-3',
      receives: 'Your voice recordings during live coaching sessions.',
      usedFor:
          'Real-time speech transcription and acoustic analysis — speaking pace, filler words, pauses.',
    ),
    (
      title: 'OpenAI Whisper',
      receives: 'Your voice recording as a transcription fallback.',
      usedFor:
          'Transcribes your speech to text when Deepgram is unavailable, ensuring sessions are never lost.',
    ),
    (
      title: 'ElevenLabs',
      receives: 'Text of your training briefings and coaching feedback.',
      usedFor:
          'Generates the spoken audio you hear from your SpeechPro Coach, using a cloned voice.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const OnboardingHeader(style: OnboardingHeaderStyle.backOnly),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 16.h, bottom: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Image.asset(
                            ImagePath.logoHeader,
                            height: 80.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'How SpeechPro uses AI',
                        style: GoogleFonts.inter(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: AppColors.pureBlack,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'SpeechPro is built on thirty years of real experience — building and growing companies, and closing deals at the highest level, with contracts worth hundreds of thousands of pounds. To deliver that experience to you personally, we use four AI services. Here is exactly what each one receives and what it does with it.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.45,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const _AccentDivider(),
                      SizedBox(height: 20.h),
                      ..._services.map(
                        (service) => Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F9),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                    color: AppColors.pureBlack,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'RECEIVES',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  service.receives,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    color: AppColors.pureBlack,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'USED FOR',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  service.usedFor,
                                  style: GoogleFonts.inter(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                    color: AppColors.pureBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SpPrimaryButton(
                        label: 'I Understand,Continue',
                        onPressed: () {
                          Get.toNamed(AppRoute.startMembershipIntro);
                        },
                      ),
                      SizedBox(height: 14.h),
                      Center(
                        child: GestureDetector(
                          onTap: Get.back,
                          child: Text(
                            'Not Now',
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentDivider extends StatelessWidget {
  const _AccentDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(size: Size(8.w, 9.h), painter: _TrianglePainter()),
        Expanded(
          child: Container(height: 0.8.h, color: const Color(0xFFF0F0F2)),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
