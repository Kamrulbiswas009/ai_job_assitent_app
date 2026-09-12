import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../model/membership_plan_model.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class AboutSpeechProScreen1 extends StatelessWidget {
  const AboutSpeechProScreen1({super.key});

  static const String routeName = '/about-speech-pro-1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const OnboardingHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our soul mission is to create an engine of success in your life.',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Divider(
                      height: 1.h,
                      thickness: 1,
                      color: AppColors.divider,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'We have spent thirty years coaching at the highest level. Our consultants charge up to £500 an hour and we make no apology for that. That is what thirty years of mastery in communication, influence and presence is worth.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.55,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'But those thirty years also taught us something that goes beyond communication.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.55,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const _DiamondBullet(
                      text:
                          'If you want to make money you have to make other people money.',
                    ),
                    SizedBox(height: 14.h),
                    const _DiamondBullet(
                      text:
                          'If you want success you have to open the doors of success for others.',
                    ),
                    SizedBox(height: 14.h),
                    const _DiamondBullet(
                      text: 'That is the reason SpeechPro exists.',
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: Text(
                        'The same mastery. The same results. Accessible\nto everyone.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.45,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const _DiamondBullet(
                      text:
                          'Your specific goal. Your specific situation. A personalised training experience built around the conversation that matters most to you right now.',
                    ),
                    SizedBox(height: 14.h),
                    const _DiamondBullet(
                      text:
                          'Seven elite training environments. Interview. Pitch. Sales. TED. Boardroom. Podcast. Social confidence. Whichever room you need to own we prepare you for it.',
                    ),
                    SizedBox(height: 14.h),
                    const _DiamondBullet(
                      text:
                          'Sixteen modules designed to build your power, influence and presence, crafted from thirty years of real-world mastery in communication and human behaviour',
                    ),
                    SizedBox(height: 14.h),
                    const _DiamondBullet(
                      text:
                          'Your Influence Score tracked in real time so you can see your authority and presence growing with every session.',
                    ),
                    SizedBox(height: 14.h),
                    const _DiamondBullet(
                      text:
                          'And when you have mastered the curriculum: SpeechPro unlocks the Create Charisma Masterclass. Where everything comes together at the highest level.',
                    ),
                    SizedBox(height: 28.h),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          color: AppColors.black,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'The person who communicates best\nwins the job.\nWins the ',
                          ),
                          TextSpan(
                            text: 'room.',
                            style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Divider(
                      height: 1.h,
                      thickness: 1,
                      color: AppColors.divider,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "This isn't a generic training app. Every drill, every piece of feedback, every doctrine inside SpeechPro comes from thirty years of coaching real people through the moments that actually mattered — the interview, the pitch, the negotiation that changed everything. Nothing here is guessed. It's tested.",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.55,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'One coffee a day. That is what this costs.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '£49 per month. Full access.\nCancel anytime.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w900,
                              height: 1.3,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Billed monthly. Cancel anytime in your App Store settings.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SpPrimaryButton(
                      label: MembershipPlanModel.monthly.buttonText,
                      onPressed: () => Get.toNamed(
                        AppRoute.membership,
                        arguments: MembershipPlanModel.monthly.toMap(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed(
                          AppRoute.membership,
                          arguments: MembershipPlanModel.threeMonths.toMap(),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primary, width: 1.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Text(
                          MembershipPlanModel.threeMonths.buttonText
                              .replaceFirst('Start Training — ', ''),
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Already subscribed? Restore purchase',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiamondBullet extends StatelessWidget {
  const _DiamondBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            '◆',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              height: 1.3,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
