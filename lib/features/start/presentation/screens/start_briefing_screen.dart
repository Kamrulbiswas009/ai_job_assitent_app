import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/start_briefing_controller.dart';
import '../widgets/briefing_processing_modal.dart';
import '../widgets/start_header.dart';

class StartBriefingScreen extends GetView<StartBriefingController> {
  const StartBriefingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const StartHeader(showLogo: false, showDivider: true),
                ),
                Expanded(
                  child: _buildBriefingContent(),
                ),
                Obx(
                  () => controller.isBriefingReady.value
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                          child: SpPrimaryButton(
                            label: 'Continue',
                            onPressed: controller.proceedToAssessment,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            // Black Box Pop-up from Client Figma Comment
            Obx(
              () => (controller.showBlackPopup.value ||
                      !controller.isBriefingReady.value)
                  ? BriefingProcessingModal(
                      onComplete: () {
                        controller.showBlackPopup.value = false;
                        controller.isBriefingReady.value = true;
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBriefingContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          _buildSpRedBadge(),
          SizedBox(height: 12.h),
          Text(
            'Job Interview',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Aycan, your personal\nbriefing',
            style: GoogleFonts.inter(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: AppColors.pureBlack,
            ),
          ),
          SizedBox(height: 24.h),
          // Section 1: What we heard
          _buildSectionHeader('What we heard'),
          SizedBox(height: 8.h),
          Text(
            'You have a job interview coming up and you want to walk in with complete authority and conviction. That intention — to own the room before a single question is asked — is exactly the right place to start. The goal here is not to perform confidence but to build the kind of settled certainty that comes through in every answer you give.',
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
            ),
          ),
          SizedBox(height: 14.h),
          // AI-generated note (clean label and text without box)
          Text(
            '✦ AI-generated',
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8E8E93),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'We will build the kind of presence that makes an interviewer feel the decision before you have finished speaking — grounded, certain, and impossible to overlook.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
            ),
          ),
          SizedBox(height: 24.h),
          // Section 2: YOUR PROGRAMME
          _buildSectionHeader('YOUR PROGRAMME'),
          SizedBox(height: 8.h),
          Text(
            'Walking in prepared is the difference between being considered and being chosen. The person on the other side of that table will decide within seven seconds whether you belong in that room and everything after that is either confirmation or recovery, which means your body language, your eye contact and the volume and pace of your first words matter more than any answer you will give.',
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Once your session is complete SpeechPro will guide you to our modules on Volume, Pace, Pauses, Body Language, Eye Contact and Confidence Under Pressure, the precise skills that make interviewers lean forward instead of lean back',
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'When you complete your module pathway SpeechPro will unlock the Create Charisma Masterclass, where everything you have built comes together at the highest level.',
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
            ),
          ),
          SizedBox(height: 28.h),
          // Section 3: Your training pillar
          _buildSectionHeader('Your training pillar', fontSize: 15),
          SizedBox(height: 6.h),
          Text(
            'Authority Through\nPresence',
            style: GoogleFonts.inter(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: AppColors.pureBlack,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'For an interview where you want complete authority and conviction, presence is the foundation — the room must feel that you have already decided you belong there.',
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
            ),
          ),
          SizedBox(height: 20.h),
          // First Principle Callout Card
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFBF0F0),
                border: Border(
                  left: BorderSide(
                    color: AppColors.primary,
                    width: 4.5,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'First principle',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'The Private Room Rule',
                    style: GoogleFonts.inter(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pureBlack,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Before you enter the interview, your internal state sets the tone for everything that follows — this doctrine trains you to arrive already settled, already authoritative, so the room receives you that way from the first moment.',
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                      color: const Color(0xFF2C2C2E),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 28.h),
          // Section 4: Put It Into Practice
          _buildSectionHeader('Put It Into Practice', fontSize: 15),
          SizedBox(height: 6.h),
          Text(
            'One practice attempt — short, focused, and done out loud.',
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              height: 1.3,
              color: AppColors.pureBlack,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Think of the single most important thing you want the interviewer to believe about you by the end of that conversation. Say it aloud as one clear, unhedged sentence — no qualifiers, no softening — and hold the silence after it. That is where your authority lives.',
            style: GoogleFonts.inter(
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF2C2C2E),
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
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSpRedBadge() {
    return Image.asset(
      ImagePath.spCircleBadge,
      width: 44.r,
      height: 44.r,
      fit: BoxFit.contain,
    );
  }
}
