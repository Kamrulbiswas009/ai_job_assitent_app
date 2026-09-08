import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: const OnboardingHeader(
                  style: OnboardingHeaderStyle.backOnly,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 9.h, bottom: 20.h),
                  child: Column(
                    children: [
                      Image.asset(
                        ImagePath.spLogoWordmark,
                        width: 333.w,
                        height: 96.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 24.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'How SpeechPro uses AI',
                          style: GoogleFonts.inter(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'SpeechPro uses four AI services to deliver your coaching. Here is exactly what each receives and what it does with it.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Divider(
                        height: 1.h,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      SizedBox(height: 24.h),
                      ..._services.map(
                        (service) => Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceGray,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'RECEIVES',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  service.receives,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  'USED FOR',
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  service.usedFor,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      SpPrimaryButton(
                        label: 'I Understand,Continue',
                        onPressed: () {
                          Get.snackbar(
                            'Onboarding complete',
                            'You can continue to the main app next.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                      ),
                      SizedBox(height: 15.h),
                      GestureDetector(
                        onTap: Get.back,
                        child: Text(
                          'Not Now',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
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
