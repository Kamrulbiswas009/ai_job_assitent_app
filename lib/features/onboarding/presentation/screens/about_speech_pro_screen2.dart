import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class AboutSpeechProScreen2 extends StatelessWidget {
  const AboutSpeechProScreen2({super.key});

  static const String routeName = '/about-speech-pro-2';

  static const _bullets = [
    'Sixteen modules designed to build your power, influence and presence, crafted from thirty years of real-world mastery in communication and human behaviour',
    'SpeechPro listens to every session and tracks your progress across six dimensions of authority and influence, so you can see your authority and presence growing with every session.',
    'Your Influence Score tracked in real time so you can see your authority and presence growing with every session.',
    'And when you have mastered the curriculum, SpeechPro unlocks the Create Charisma Masterclass. Where everything comes together at the highest level.',
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
                  padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The same mastery. The same results. Accessible to everyone.',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Divider(
                        height: 1.h,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'Your specific goal. Your specific situation. A personalised training experience built around the conversation that matters most to you right now',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Seven elite training environments. Interview. Pitch. Sales. TED. Boardroom. Podcast. Social confidence. Whichever room you need to own we prepare you for it.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      ..._bullets.map(
                        (text) => Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '◆',
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  text,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: AppColors.black,
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
              SpPrimaryButton(
                label: 'Next',
                onPressed: () => Get.toNamed(AppRoute.about3),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
