import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../model/membership_plan_model.dart';
import '../widgets/checkout_confirmation_sheet.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  static const String routeName = '/membership';

  static const _features = [
    'SpeechPro training for every high-stakes conversation',
    '16-module mastery curriculum',
    '7 training environments',
    'Influence Score — track your progress',
    'Personalised module guidance after every session',
  ];

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final MembershipPlanModel plan = args is Map
        ? MembershipPlanModel.fromMap(args.cast<String, dynamic>())
        : (args is MembershipPlanModel ? args : MembershipPlanModel.monthly);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const OnboardingHeader(style: OnboardingHeaderStyle.backOnly),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Membership',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Start training today.',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: AppColors.pureBlack,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const _AccentDivider(),
                      SizedBox(height: 24.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 22.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F9),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  plan.price,
                                  style: GoogleFonts.inter(
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                    color: AppColors.pureBlack,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6.h),
                                  child: Text(
                                    plan.period,
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF8E8E93),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Full access to SpeechPro. Cancel anytime.',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                                color: const Color(0xFF8E8E93),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            Container(
                              height: 0.8.h,
                              color: const Color(0xFFE5E5EA),
                            ),
                            SizedBox(height: 18.h),
                            ..._features.map(
                              (feature) => Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 18.w,
                                      height: 18.w,
                                      margin: EdgeInsets.only(top: 2.h),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFEE8E8),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        IconPath.icCheckSmall,
                                        width: 10.w,
                                        height: 10.w,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.4,
                                          color: AppColors.pureBlack,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SpPrimaryButton(
                label: plan.buttonText,
                onPressed: () =>
                    CheckoutConfirmationSheet.show(context, plan: plan),
              ),
              SizedBox(height: 14.h),
              Text(
                plan.billingText,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: const Color(0xFF8E8E93),
                ),
              ),
              SizedBox(height: 180.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccentDivider extends StatelessWidget {
  const _AccentDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(size: Size(8.w, 9.h), painter: _TrianglePainter()),
        Expanded(
          child: Container(height: 0.8.h, color: const Color(0xFFF0F0F2)),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
