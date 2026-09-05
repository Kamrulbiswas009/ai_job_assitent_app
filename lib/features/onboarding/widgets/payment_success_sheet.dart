import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/onboarding_assets.dart';
import '../constants/onboarding_colors.dart';
import '../screens/uses_of_ai_screen.dart';
import 'sp_primary_button.dart';

class PaymentSuccessSheet extends StatelessWidget {
  const PaymentSuccessSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: OnboardingColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(32.w, 39.h, 32.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            OnboardingAssets.icSuccessCheck,
            width: 112.w,
            height: 112.w,
          ),
          SizedBox(height: 29.h),
          Text(
            'Payment Successful',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: OnboardingColors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Welcome to SpeechPro.Your membership is active',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: OnboardingColors.pureBlack,
            ),
          ),
          SizedBox(height: 27.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: OnboardingColors.surfaceGray,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: OnboardingColors.gray,
                      ),
                    ),
                    Text(
                      '£49',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: OnboardingColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                Divider(height: 1.h, color: OnboardingColors.divider),
                SizedBox(height: 11.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction ID',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: OnboardingColors.gray,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingColors.purpleSoft,
                        borderRadius: BorderRadius.circular(17.r),
                        border: Border.all(color: OnboardingColors.purple),
                      ),
                      child: Text(
                        'TXN-4522',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: OnboardingColors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Billing',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: OnboardingColors.gray,
                      ),
                    ),
                    Text(
                      'Monthly',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: OnboardingColors.gray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
          SpPrimaryButton(
            label: 'Payment Complete',
            onPressed: () {
              Get.back();
              Get.toNamed(UsesOfAiScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
