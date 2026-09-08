import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const String routeName = '/registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _agreed = false;

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
                        'Create your account',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'Start your communication baseline today.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.gray,
                        ),
                      ),
                      SizedBox(height: 35.h),
                      const SpUnderlineField(
                        label: 'Full Name',
                        hint: 'James Davidson',
                      ),
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 20.h),
                      const SpUnderlineField(
                        label: 'Confirm Password',
                        hint: 'Re-enter your password',
                        obscureText: true,
                        showObscureToggle: true,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _agreed = !_agreed),
                            child: Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: AppColors.gray.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1.5,
                                ),
                                color: _agreed
                                    ? AppColors.primary
                                    : AppColors.transparent,
                              ),
                              child: _agreed
                                  ? Icon(
                                      Icons.check,
                                      size: 14.sp,
                                      color: AppColors.white,
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              "By continuing you agree to SpeechPro's Terms of Service and Privacy Policy. Your voice data is processed securely and never shared.",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 48.h),
                      SpPrimaryButton(
                        label: 'Create Account',
                        onPressed: () =>
                            Get.toNamed(AppRoute.verification),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: AppColors.gray,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.offAllNamed(AppRoute.login),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
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
