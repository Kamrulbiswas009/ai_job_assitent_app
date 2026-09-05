import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/onboarding_colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';
import 'onboarding_login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  static const String routeName = '/reset-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingHeader(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 26.h),
                    Text(
                      'Reset Password',
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: OnboardingColors.black,
                      ),
                    ),
                    Text(
                      "You are all set. Now it's time to create a new password.",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: OnboardingColors.gray,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    const SpUnderlineField(
                      label: 'New Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      showObscureToggle: true,
                    ),
                    SizedBox(height: 20.h),
                    const SpUnderlineField(
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      obscureText: true,
                      showObscureToggle: true,
                    ),
                    const Spacer(),
                    SpPrimaryButton(
                      label: 'Reset Password',
                      onPressed: () =>
                          Get.offAllNamed(OnboardingLoginScreen.routeName),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
