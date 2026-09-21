import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../routes/app_routes.dart';
import '../../model/membership_plan_model.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/sp_primary_button.dart';

class AboutSpeechProScreen1 extends StatelessWidget {
  const AboutSpeechProScreen1({super.key});

  static const String routeName = '/about-speech-pro-1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const OnboardingHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Our soul mission is to create an engine of success in your life.',
                      style: GoogleFonts.inter(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const _AccentDivider(),
                    SizedBox(height: 14.h),
                    Text(
                      'We have spent thirty years coaching at the highest level. Our consultants charge up to £500 an hour and we make no apology for that. That is what thirty years of mastery in communication, influence and presence is worth.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'But those thirty years also taught us something that goes beyond communication.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    const _DiamondBullet(
                      text:
                          'If you want to make money you have to make other people money.',
                    ),
                    const _DiamondBullet(
                      text:
                          'If you want success you have to open the doors of success for others.',
                    ),
                    const _DiamondBullet(
                      text: 'That is the reason SpeechPro exists.',
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        'The same mastery. The same results. Accessible\nto everyone.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15.5.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const _DiamondBullet(
                      text:
                          'Your specific goal. Your specific situation. A personalised training experience built around the conversation that matters most to you right now.',
                    ),
                    const _DiamondBullet(
                      text:
                          'Seven elite training environments. Interview. Pitch. Sales. TED. Boardroom. Podcast. Social confidence. Whichever room you need to own we prepare you for it.',
                    ),
                    const _DiamondBullet(
                      text:
                          'Sixteen modules designed to build your power, influence and presence, crafted from thirty years of real-world mastery in communication and human behaviour',
                    ),
                    const _DiamondBullet(
                      text:
                          'Your Influence Score tracked in real time so you can see your authority and presence growing with every session.',
                    ),
                    const _DiamondBullet(
                      text:
                          'And when you have mastered the curriculum SpeechPro unlocks the Create Charisma Masterclass. Where everything comes together at the highest level.',
                    ),
                    SizedBox(height: 20.h),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: AppColors.pureBlack,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'The person who communicates best\nwins the job.\nWins the ',
                          ),
                          TextSpan(
                            text: 'room.',
                            style: GoogleFonts.inter(
                              fontSize: 21.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const _AccentDivider(),
                    SizedBox(height: 14.h),
                    Text(
                      "This isn't a generic training app. Every drill, every piece of feedback, every doctrine inside SpeechPro comes from thirty years of coaching real people through the moments that actually mattered — the interview, the pitch, the negotiation that changed everything. Nothing here is guessed. It's tested.",
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'One coffee a day. That is what this costs.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '£49 per month. Full access.\nCancel anytime.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 21.sp,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                              color: AppColors.pureBlack,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            'Billed monthly. Cancel anytime in your App Store settings.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.h),
                    SpPrimaryButton(
                      label: MembershipPlanModel.monthly.buttonText,
                      onPressed: () => Get.toNamed(
                        AppRoute.membership,
                        arguments: MembershipPlanModel.monthly.toMap(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: OutlinedButton(
                        onPressed: () => Get.toNamed(
                          AppRoute.membership,
                          arguments: MembershipPlanModel.threeMonths.toMap(),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                          backgroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          MembershipPlanModel.threeMonths.buttonText
                              .replaceFirst('Start Training — ', ''),
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          EasyLoading.showInfo('Checking for existing subscriptions...');
                        },
                        child: Text(
                          'Already subscribed? Restore purchase',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ],
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

class _DiamondBullet extends StatelessWidget {
  const _DiamondBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees
              child: Container(
                width: 9.5.w,
                height: 9.5.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(0.8.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.48,
                color: AppColors.pureBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
