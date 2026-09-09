import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class OnboardingLoginScreen extends StatelessWidget {
  const OnboardingLoginScreen({super.key});

  static const String routeName = '/onboarding-login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24.h),
                              Text(
                                'Welcome back',
                                style: GoogleFonts.inter(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                'Sign in to continue your training.',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: AppColors.gray,
                                ),
                              ),
                              SizedBox(height: 32.h),
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
                                onTap: () =>
                                    Get.toNamed(AppRoute.forgotPassword),
                                child: Text(
                                  'Forgot password?',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(height: 24.h),
                              SpPrimaryButton(
                                label: 'Sign In',
                                onPressed: () => Get.toNamed(AppRoute.about1),
                              ),
                              SizedBox(height: 12.h),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.5,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          Get.toNamed(AppRoute.registration),
                                      child: Text(
                                        'Create one',
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
                              ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
