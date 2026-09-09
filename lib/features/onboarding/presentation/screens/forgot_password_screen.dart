import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static const String routeName = '/forgot-password';

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
                                'Forgot Password !',
                                style: GoogleFonts.inter(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                "Do you forgot your password, It's ease to reset, just provide your email address, We'll send you a OTP code..",
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
                              const Spacer(),
                              SizedBox(height: 24.h),
                              SpPrimaryButton(
                                label: 'Send OTP',
                                onPressed: () => Get.toNamed(
                                  AppRoute.resetPasswordVerification,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              SizedBox(
                                width: double.infinity,
                                height: 53.h,
                                child: OutlinedButton(
                                  onPressed: Get.back,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.divider),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      color: AppColors.black,
                                    ),
                                  ),
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
