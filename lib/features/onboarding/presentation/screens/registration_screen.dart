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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  static const String routeName = '/registration';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final OnboardingController _controller = Get.find<OnboardingController>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreed = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      EasyLoading.showInfo('Please enter your full name');
      return;
    }

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      EasyLoading.showInfo('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      EasyLoading.showInfo('Please enter your password');
      return;
    }

    if (password != confirmPassword) {
      EasyLoading.showInfo('Passwords do not match');
      return;
    }

    if (!_agreed) {
      EasyLoading.showInfo('Please accept the Terms of Service to continue');
      return;
    }

    final isSuccess = await _controller.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    if (isSuccess) {
      Get.offNamed(AppRoute.verification, arguments: {'email': email});
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
            children: [
              const OnboardingHeader(),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
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
                                'Create your account',
                                style: GoogleFonts.inter(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                  color: AppColors.pureBlack,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Start your communication baseline today.',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                  color: const Color(0xFF71717A),
                                ),
                              ),
                              SizedBox(height: 28.h),
                              SpUnderlineField(
                                controller: _fullNameController,
                                label: 'Full Name',
                                hint: 'James Davidson',
                              ),
                              SizedBox(height: 20.h),
                              SpUnderlineField(
                                controller: _emailController,
                                label: 'Email Address',
                                hint: 'james@example.com',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 20.h),
                              SpUnderlineField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: 'Create a password',
                                obscureText: true,
                                showObscureToggle: true,
                              ),
                              SizedBox(height: 20.h),
                              SpUnderlineField(
                                controller: _confirmPasswordController,
                                label: 'Confirm Password',
                                hint: 'Confirm your password',
                                obscureText: true,
                                showObscureToggle: true,
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _agreed = !_agreed),
                                    child: Container(
                                      width: 20.w,
                                      height: 20.w,
                                      margin: EdgeInsets.only(top: 2.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
                                        border: Border.all(
                                          color: _agreed
                                              ? AppColors.primary
                                              : const Color(0xFFD1D5DB),
                                          width: 1.5,
                                        ),
                                        color: _agreed
                                            ? AppColors.primary
                                            : AppColors.white,
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
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _agreed = !_agreed),
                                      behavior: HitTestBehavior.opaque,
                                      child: Text(
                                        "By continuing you agree to SpeechPro's Terms of Service and Privacy Policy. Your voice data is processed securely and never shared.",
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.45,
                                          color: const Color(0xFF71717A),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SizedBox(height: 24.h),
                              Obx(
                                () => SpPrimaryButton(
                                  label: 'Create Account',
                                  isLoading: _controller.isRegisterLoading.value,
                                  onPressed: _handleRegister,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Center(
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      'Already have an account? ',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.4,
                                        color: const Color(0xFF71717A),
                                      ),
                                    ),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => Get.toNamed(AppRoute.login),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.h,
                                          horizontal: 2.w,
                                        ),
                                        child: Text(
                                          'Sign In',
                                          style: GoogleFonts.inter(
                                            fontSize: 12.5.sp,
                                            fontWeight: FontWeight.w700,
                                            height: 1.4,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
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
