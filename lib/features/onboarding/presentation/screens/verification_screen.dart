import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/onboarding_controller.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  static const String routeName = '/verification';

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final OnboardingController _controller = Get.find<OnboardingController>();

  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  String _email = '';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['email'] != null) {
      _email = args['email'].toString();
    } else if (_controller.registeredEmail.value.isNotEmpty) {
      _email = _controller.registeredEmail.value;
    } else if (StorageService.userEmail != null &&
        StorageService.userEmail!.isNotEmpty) {
      _email = StorageService.userEmail!;
    } else {
      _email = 'gulamrosul037@gmail.com';
    }
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _handleVerify() async {
    final otp = _otpControllers.map((c) => c.text.trim()).join();

    if (otp.length < 6) {
      Get.snackbar(
        'Incomplete Code',
        'Please enter the full 6-digit verification code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
      return;
    }

    final isSuccess = await _controller.verifyEmail(
      email: _email,
      otp: otp,
    );

    if (isSuccess) {
      Get.offAllNamed(
        AppRoute.login,
        arguments: {'email': _email},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OnboardingHeader(showBackButton: false),
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
                                        text: _email,
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
                                        controller: _otpControllers[index],
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
                                          if (index == 5 && value.isNotEmpty) {
                                            _nodes[index].unfocus();
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),
                                const Spacer(),
                                SizedBox(height: 24.h),
                                Obx(
                                  () => SpPrimaryButton(
                                    label: 'Verify email',
                                    isLoading: _controller.isVerifyLoading.value,
                                    onPressed: _handleVerify,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Center(
                                  child: Obx(
                                    () {
                                      final count =
                                          _controller.resendCountdown.value;
                                      return GestureDetector(
                                        onTap: count == 0
                                            ? () {
                                                _controller.startResendTimer();
                                                Get.snackbar(
                                                  'Resent',
                                                  'Verification code resent to $_email',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor:
                                                      Colors.blue.shade600,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            : null,
                                        child: RichText(
                                          text: TextSpan(
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 1.5,
                                              color: AppColors.gray,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: count > 0
                                                    ? 'Resend in '
                                                    : 'Didn\'t receive code? ',
                                              ),
                                              TextSpan(
                                                text: count > 0
                                                    ? '${count}s'
                                                    : 'Resend',
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
                                      );
                                    },
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
      ),
    );
  }
}
