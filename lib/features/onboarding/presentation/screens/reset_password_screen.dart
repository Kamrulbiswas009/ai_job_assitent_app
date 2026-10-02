import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String routeName = '/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final OnboardingController _controller = Get.find<OnboardingController>();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _email = '';
  String _otp = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map) {
      if (args['email'] != null) _email = args['email'].toString();
      if (args['otp'] != null) _otp = args['otp'].toString();
    }
    if (_email.isEmpty) {
      _email = _controller.resetPasswordEmail.value;
    }
    if (_otp.isEmpty) {
      _otp = _controller.resetPasswordOtp.value;
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty) {
      EasyLoading.showInfo('Please enter your new password');
      return;
    }

    if (newPassword.length < 6) {
      EasyLoading.showInfo('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword.isEmpty) {
      EasyLoading.showInfo('Please confirm your password');
      return;
    }

    if (newPassword != confirmPassword) {
      EasyLoading.showInfo('Passwords do not match');
      return;
    }

    final isSuccess = await _controller.resetPassword(
      email: _email,
      otp: _otp,
      newPassword: newPassword,
    );

    if (isSuccess) {
      Get.offAllNamed(AppRoute.login);
    }
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
                              SpUnderlineField(
                                controller: _newPasswordController,
                                label: 'New Password',
                                hint: 'Enter your password',
                                obscureText: true,
                                showObscureToggle: true,
                              ),
                              SizedBox(height: 20.h),
                              SpUnderlineField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Re-enter your password',
                                obscureText: true,
                                showObscureToggle: true,
                              ),
                              const Spacer(),
                              SizedBox(height: 24.h),
                              Obx(
                                () => SpPrimaryButton(
                                  label: 'Reset Password',
                                  isLoading:
                                      _controller.isResetPasswordLoading.value,
                                  onPressed: _handleResetPassword,
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
