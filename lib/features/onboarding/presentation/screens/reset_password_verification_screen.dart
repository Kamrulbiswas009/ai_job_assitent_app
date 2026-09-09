import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class ResetPasswordVerificationScreen extends StatefulWidget {
  const ResetPasswordVerificationScreen({super.key});

  static const String routeName = '/reset-password-verification';

  @override
  State<ResetPasswordVerificationScreen> createState() =>
      _ResetPasswordVerificationScreenState();
}

class _ResetPasswordVerificationScreenState
    extends State<ResetPasswordVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

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
                                'Check your email',
                                style: GoogleFonts.inter(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                  color: AppColors.black,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    color: AppColors.gray,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'We sent a 6-digit code to  ',
                                    ),
                                    TextSpan(
                                      text: 'ZCX@gmail.com',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Text(
                                'Verification code',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: AppColors.gray,
                                ),
                              ),
                              SizedBox(height: 11.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) {
                                  return SizedBox(
                                    width: 54.w,
                                    height: 54.w,
                                    child: TextField(
                                      controller: _controllers[index],
                                      focusNode: _nodes[index],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style: GoogleFonts.inter(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          borderSide: BorderSide(
                                            color: AppColors.border,
                                            width: 2,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          borderSide: BorderSide(
                                            color: AppColors.primary,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty && index < 5) {
                                          _nodes[index + 1].requestFocus();
                                        } else if (value.isEmpty && index > 0) {
                                          _nodes[index - 1].requestFocus();
                                        }
                                      },
                                    ),
                                  );
                                }),
                              ),
                              const Spacer(),
                              SizedBox(height: 24.h),
                              SpPrimaryButton(
                                label: 'Verify email',
                                onPressed: () =>
                                    Get.toNamed(AppRoute.resetPassword),
                              ),
                              SizedBox(height: 12.h),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      color: AppColors.gray,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Resend in '),
                                      TextSpan(
                                        text: '25s',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          height: 1.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
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
