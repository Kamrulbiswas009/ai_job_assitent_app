import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  static const String routeName = '/reset-password';

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
                                'Reset Password',
                                style: GoogleFonts.inter(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  color: AppColors.black,
                                ),
                              ),
                              Text(
                                "You are all set. Now it's time to create a new password.",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.5,
                                  color: AppColors.gray,
                                ),
                              ),
                              SizedBox(height: 32.h),
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
                              SizedBox(height: 24.h),
                              SpPrimaryButton(
                                label: 'Reset Password',
                                onPressed: () =>
                                    Get.offAllNamed(AppRoute.login),
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
