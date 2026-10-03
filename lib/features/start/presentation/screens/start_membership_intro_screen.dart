import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/start_membership_controller.dart';

class StartMembershipIntroScreen extends GetView<StartMembershipController> {
  const StartMembershipIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadUserData();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              // Logo
              Center(
                child: Image.asset(
                  ImagePath.logoHeader,
                  height: 44.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 14.h),
              _sectionLabel('WELCOME TO SPEECHPRO'),
              SizedBox(height: 6.h),
              // Main heading
              Obx(() {
                final rawName = controller.userFirstName.value.trim();
                final firstName = rawName.isNotEmpty
                    ? '${rawName[0].toUpperCase()}${rawName.substring(1)}'
                    : (controller.userName.value.trim().isNotEmpty
                        ? controller.userName.value.trim().split(' ').first
                        : '');
                final headingStyle = GoogleFonts.inter(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  letterSpacing: -0.4,
                  color: AppColors.pureBlack,
                );
                return Text.rich(
                  TextSpan(
                    style: headingStyle,
                    children: firstName.isNotEmpty
                        ? [
                            TextSpan(
                              text: firstName,
                              style: headingStyle.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ', your voice is about to become your advantage.',
                            ),
                          ]
                        : const [
                            TextSpan(
                              text:
                                  'Your voice is about to become your advantage.',
                            ),
                          ],
                  ),
                );
              }),
              SizedBox(height: 12.h),
              Text(
                'You now have access to 30 years of growth and communication experience in an application that you can train with every time you need it.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.45,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 14.h),
              // Hero image
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.asset(
                  ImagePath.introWoman,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.3, -0.3),
                ),
              ),
              SizedBox(height: 14.h),
              // Foundation card
              _buildFoundationCard(),
              SizedBox(height: 14.h),
              // Video / quote card
              _buildVideoCard(),
              SizedBox(height: 18.h),
              _sectionLabel('WHAT HAPPENS NEXT?'),
              SizedBox(height: 12.h),
              _buildNextStep(
                Icons.alt_route_rounded,
                'Build your training path',
                'Tell us what you want to achieve and we\'ll create a personalised plan.',
              ),
              _buildNextStep(
                Icons.graphic_eq_rounded,
                'Start your first practice session',
                'Jump into a real-world scenario with AI roleplay and expert coaching.',
              ),
              _buildNextStep(
                Icons.show_chart_rounded,
                'Track your progress',
                'See measurable improvements across the six dimensions of influence.',
                isLast: true,
              ),
              SizedBox(height: 18.h),
              // Journey CTA card
              _buildJourneyCard(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildFoundationCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 6.h),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('YOUR SPEECHPRO FOUNDATION'),
          SizedBox(height: 10.h),
          _buildPillarRow(
            Icons.chat_bubble_outline_rounded,
            'Power Through Speech',
            'Build control, clarity and confidence.',
            '01',
          ),
          _pillarDivider(),
          _buildPillarRow(
            Icons.groups_outlined,
            'Influence Through Impact',
            'Make your words move people.',
            '02',
          ),
          _pillarDivider(),
          _buildPillarRow(
            Icons.graphic_eq_rounded,
            'Authority Through Presence',
            'Command attention before you say a word.',
            '03',
          ),
        ],
      ),
    );
  }

  Widget _pillarDivider() => const Divider(
        height: 1,
        thickness: 0.8,
        color: AppColors.divider,
      );

  Widget _buildPillarRow(
    IconData icon,
    String title,
    String subtitle,
    String number,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: AppColors.pureBlack,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primaryTint,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: SizedBox(
        width: double.infinity,
        height: 195.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              ImagePath.introSpeaker,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.6),
            ),
            // Bottom dark gradient
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.pureBlack.withValues(alpha: 0.05),
                    AppColors.pureBlack.withValues(alpha: 0.35),
                    AppColors.pureBlack.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
            // Play button
            Align(
              alignment: const Alignment(0, -0.35),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.pureBlack.withValues(alpha: 0.25),
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.white,
                  size: 26.sp,
                ),
              ),
            ),
            // Quote
            Positioned(
              left: 12.w,
              right: 12.w,
              bottom: 12.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  Text(
                    'Your voice creates opportunities, builds relationships and changes outcomes.',
                    style: GoogleFonts.inter(
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '— Marcus',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'SpeechPro Coach',
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStep(
    IconData icon,
    String title,
    String subtitle, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    color: AppColors.pureBlack,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('YOUR JOURNEY STARTS HERE'),
          SizedBox(height: 8.h),
          Text(
            'What do you want to achieve?',
            style: GoogleFonts.inter(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.3,
              color: AppColors.pureBlack,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Choose your main goal and create your SpeechPro training path.',
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 16.h),
          SpPrimaryButton(
            label: 'Build My Training Path',
            onPressed: controller.goToStep1,
            height: 48.h,
            borderRadius: 10.r,
            textStyle: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
