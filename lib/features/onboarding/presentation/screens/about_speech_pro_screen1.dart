import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const OnboardingHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our soul mission is to create an engine of success in your life.',
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
                        'We have spent thirty years coaching at the highest level. Our consultants charge up to £500 an hour and we make no apology for that. That is what thirty years of mastery in communication, influence and presence is worth.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'But those thirty years also taught us something that goes beyond communication.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      const _DiamondBullet(
                        text:
                            'If you want to make money you have to make other people money.',
                      ),
                      SizedBox(height: 16.h),
                      const _DiamondBullet(
                        text:
                            'If you want success you have to open the doors of success for others.',
                      ),
                      SizedBox(height: 16.h),
                      const _DiamondBullet(
                        text: 'That is the reason SpeechPro exists.',
                      ),
                    ],
                  ),
                ),
              ),
              SpPrimaryButton(
                label: 'Next',
                onPressed: () => Get.toNamed(AppRoute.about2),
              ),
              SizedBox(height: 18.h),
            ],
          ),
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
        Text(
          '◆',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            height: 1,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 9.w),
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
    );
  }
}
