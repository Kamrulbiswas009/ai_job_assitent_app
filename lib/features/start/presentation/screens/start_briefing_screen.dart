import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/start_briefing_controller.dart';
import '../widgets/start_header.dart';

class StartBriefingScreen extends GetView<StartBriefingController> {
  const StartBriefingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(showLogo: false),
            ),
            Expanded(
              child: Obx(() {
                if (!controller.isBriefingReady.value) {
                  return _buildLoadingState();
                }
                return _buildBriefingContent();
              }),
            ),
            Obx(
              () => controller.isBriefingReady.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      child: SpPrimaryButton(
                        label: 'Continue',
                        onPressed: controller.proceedToAssessment,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildSpRedBadge(),
              SizedBox(width: 8.w),
              Text(
                'Job Interview',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Aycan, your personal briefing',
            style: GoogleFonts.inter(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Preparing your briefing…',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF888888),
            ),
          ),
          SizedBox(height: 24.h),
          Obx(
            () => _buildStepLoader(
              'Absorbing what you have shared',
              isComplete: controller.briefingLoadingStage.value >= 1,
              isActive: controller.briefingLoadingStage.value == 0,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(
            () => _buildStepLoader(
              'Structuring our response',
              isComplete: controller.briefingLoadingStage.value >= 2,
              isActive: controller.briefingLoadingStage.value == 1,
            ),
          ),
          const Spacer(),
          Center(
            child: SizedBox(
              width: 32.r,
              height: 32.r,
              child: const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildStepLoader(String title, {required bool isComplete, required bool isActive}) {
    return Row(
      children: [
        Container(
          width: 20.r,
          height: 20.r,
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.primary
                : (isActive ? const Color(0xFFFFECEC) : const Color(0xFFF2F2F7)),
            shape: BoxShape.circle,
            border: Border.all(
              color: isComplete || isActive
                  ? AppColors.primary
                  : const Color(0xFFD1D1D6),
            ),
          ),
          child: isComplete
              ? Icon(Icons.check, size: 13.sp, color: AppColors.white)
              : (isActive
                  ? Center(
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: isComplete || isActive ? AppColors.black : const Color(0xFF888888),
          ),
        ),
      ],
    );
  }

  Widget _buildBriefingContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildSpRedBadge(),
              SizedBox(width: 8.w),
              Text(
                'Job Interview',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Aycan, your personal briefing',
            style: GoogleFonts.inter(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 28.h),
          // What we heard
          _buildSectionHeader('What we heard'),
          SizedBox(height: 8.h),
          Text(
            'You have a job interview coming up and you want to walk in with complete authority and conviction. That intention — to own the room before a single question is asked — is exactly the right place to start. The goal here is not to perform confidence but to build the kind of settled certainty that comes through in every answer you give.',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 16.h),
          // AI-generated note
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✦ AI-generated',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'We will build the kind of presence that makes an interviewer feel the decision before you have finished speaking — grounded, certain, and impossible to overlook.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: const Color(0xFF0A0A0A),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // YOUR PROGRAMME
          _buildSectionHeader('YOUR PROGRAMME'),
          SizedBox(height: 8.h),
          Text(
            'Walking in prepared is the difference between being considered and being chosen. The person on the other side of that table will decide within seven seconds whether you belong in that room and everything after that is either confirmation or recovery, which means your body language, your eye contact and the volume and pace of your first words matter more than any answer you will give.',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Once your session is complete SpeechPro will guide you to our modules on Volume, Pace, Pauses, Body Language, Eye Contact and Confidence Under Pressure, the precise skills that make interviewers lean forward instead of lean back',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'When you complete your module pathway SpeechPro will unlock the Create Charisma Masterclass, where everything you have built comes together at the highest level.',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 28.h),
          // Your training pillar
          _buildSectionHeader('Your training pillar', fontSize: 20),
          SizedBox(height: 4.h),
          Text(
            'Authority Through Presence',
            style: GoogleFonts.inter(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'For an interview where you want complete authority and conviction, presence is the foundation — the room must feel that you have already decided you belong there.',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 20.h),
          // First Principle Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F7),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFFFD4D4), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'First principle',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'The Private Room Rule',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Before you enter the interview, your internal state sets the tone for everything that follows — this doctrine trains you to arrive already settled, already authoritative, so the room receives you that way from the first moment.',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: const Color(0xFF0A0A0A),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          // Your first rep
          _buildSectionHeader('Your first rep', fontSize: 20),
          SizedBox(height: 8.h),
          Text(
            'Think of the single most important thing you want the interviewer to believe about you by the end of that conversation. Say it aloud as one clear, unhedged sentence — no qualifiers, no softening — and hold the silence after it. That is where your authority lives.',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              height: 1.4,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {double fontSize = 14}) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSpRedBadge() {
    return Image.asset(
      ImagePath.spLogoMark,
      width: 26.r,
      height: 26.r,
      fit: BoxFit.contain,
    );
  }
}
