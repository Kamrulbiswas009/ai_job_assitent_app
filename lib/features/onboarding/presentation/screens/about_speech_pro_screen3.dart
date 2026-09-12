import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../model/membership_plan_model.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class AboutSpeechProScreen3 extends StatelessWidget {
  const AboutSpeechProScreen3({super.key});

  static const String routeName = '/about-speech-pro-3';

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
                        'The person who communicates best wins the job.',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                            color: AppColors.black,
                          ),
                          children: [
                            const TextSpan(text: 'Wins the '),
                            TextSpan(
                              text: 'room.',
                              style: GoogleFonts.inter(
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Divider(
                        height: 1.h,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'The AI analyses not just what you say but how you say it  pace, pause, filler words, and vocal confidence giving you evidence-based feedback after every session.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'One coffee a day. That is what this costs.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: AppColors.gray,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              '£49 per month. Full access.\nCancel anytime.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w900,
                                height: 1.5,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Text(
                        'Billed monthly. Cancel anytime in your App Store settings.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpPrimaryButton(
                label: MembershipPlanModel.monthly.buttonText,
                onPressed: () => Get.toNamed(
                  AppRoute.membership,
                  arguments: MembershipPlanModel.monthly.toMap(),
                ),
              ),
              SizedBox(height: 13.h),
              Text(
                'Already subscribed? Restore purchase',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
