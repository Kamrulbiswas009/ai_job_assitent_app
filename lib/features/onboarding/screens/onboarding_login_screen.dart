import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/onboarding_colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';
import 'about_speech_pro_screen1.dart';
import 'forgot_password_screen.dart';
import 'registration_screen.dart';

class OnboardingLoginScreen extends StatelessWidget {
  const OnboardingLoginScreen({super.key});

  static const String routeName = '/onboarding-login';

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
                      'Welcome back',
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: OnboardingColors.black,
                      ),
                    ),
                    Text(
                      'Sign in to continue your training.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: OnboardingColors.gray,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    const SpUnderlineField(
                      label: 'Email Address',
                      hint: 'james@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    const SpUnderlineField(
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      showObscureToggle: true,
                    ),
                    SizedBox(height: 13.h),
                    GestureDetector(
                      onTap: () => Get.toNamed(ForgotPasswordScreen.routeName),
                      child: Text(
                        'Forgot password?',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: OnboardingColors.primary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SpPrimaryButton(label: 'Sign In', onPressed: () => {}),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: OnboardingColors.gray,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              Get.offNamed(RegistrationScreen.routeName),
                          child: Text(
                            'Create one',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: OnboardingColors.primary,
                            ),
                          ),
                        ),
                      ],
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
