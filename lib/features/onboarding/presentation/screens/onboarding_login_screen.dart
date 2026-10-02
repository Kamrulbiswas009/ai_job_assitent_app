import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class OnboardingLoginScreen extends StatefulWidget {
  const OnboardingLoginScreen({super.key});

  static const String routeName = '/onboarding-login';

  @override
  State<OnboardingLoginScreen> createState() => _OnboardingLoginScreenState();
}

class _OnboardingLoginScreenState extends State<OnboardingLoginScreen> {
  final OnboardingController _controller = Get.find<OnboardingController>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['email'] != null) {
      _emailController.text = args['email'].toString();
    } else if (_controller.registeredEmail.value.isNotEmpty) {
      _emailController.text = _controller.registeredEmail.value;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      EasyLoading.showInfo('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      EasyLoading.showInfo('Please enter your password');
      return;
    }

    final isSuccess = await _controller.login(email: email, password: password);

    if (isSuccess) {
      final isSubscribed =
          _controller.isUserSubscribed.value || StorageService.isSubscribed;
      if (isSubscribed) {
        final fullName = _controller.userFullName.value.isNotEmpty
            ? _controller.userFullName.value
            : (StorageService.fullName ?? '');
        Get.offAllNamed(
          AppRoute.startMembershipIntro,
          arguments: {'fullName': fullName},
        );
      } else {
        Get.offAllNamed(AppRoute.about1);
      }
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
                              Obx(
                                () => SpPrimaryButton(
                                  label: 'Sign In',
                                  isLoading: _controller.isLoginLoading.value,
                                  onPressed: _handleLogin,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account? ",
                                        style: GoogleFonts.inter(
                                          fontSize: 12.5.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                          color: AppColors.gray,
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            Get.toNamed(AppRoute.registration),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6.h,
                                            horizontal: 4.w,
                                          ),
                                          child: Text(
                                            'Create one',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.5.sp,
                                              fontWeight: FontWeight.w700,
                                              height: 1.5,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
