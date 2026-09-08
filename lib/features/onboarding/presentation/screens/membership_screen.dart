import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  static const String routeName = '/membership';

  static const _features = [
    'SpeechPro training for every high-stakes conversation',
    '16-module mastery curriculum',
    '7 training environments',
    'Influence Score — track your progress',
    'Personalised module guidance after every session',
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
                        'Your Membership',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Start training today.',
                        style: GoogleFonts.inter(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Divider(
                        height: 1.h,
                        thickness: 1,
                        color: AppColors.divider,
                      ),
                      SizedBox(height: 26.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceGray,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '£49',
                                  style: GoogleFonts.inter(
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Text(
                                    '/month',
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7.h),
                            Text(
                              'Full access to SpeechPro. Cancel anytime.',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: AppColors.gray,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Divider(
                              height: 1.h,
                              color: AppColors.divider,
                            ),
                            SizedBox(height: 15.h),
                            ..._features.map(
                              (feature) => Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        IconPath.icCheckSmall,
                                        width: 11.w,
                                        height: 11.w,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        feature,
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
                    ],
                  ),
                ),
              ),
              SpPrimaryButton(
                label: 'Start Training — £49/month',
                onPressed: () => Get.toNamed(AppRoute.checkout),
              ),
              SizedBox(height: 13.h),
              Text(
                'Billed monthly. Cancel anytime in your App Store settings.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color: AppColors.gray,
                ),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
