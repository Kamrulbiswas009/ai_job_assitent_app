import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/practice_coaching_brief_controller.dart';
import '../widgets/practice_app_bar.dart';

class PracticeCoachingBriefScreen
    extends GetView<PracticeCoachingBriefController> {
  const PracticeCoachingBriefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = controller.briefData.value;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PracticeAppBar(isRoot: false),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Tag: Inter 600, Size 16, Color #E60008
                    Text(
                      data.welcomeTag,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE60008),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Title: Inter 700, Size 28, LetterSpacing -0.5, Color #0A0A0A
                    Text(
                      data.sessionTitle,
                      style: GoogleFonts.inter(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A0A0A),
                        height: 1.25,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Subtitle: Inter 400, Size 16, Color #666666
                    Text(
                      data.sessionSubtitle,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF666666),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Coaching Brief Video Card (Figma Radius 12)
                    _buildVideoBriefCard(data),
                    SizedBox(height: 20.h),

                    // Coach Focus Box (Figma Pad L16 R16 T16 B16, Radius 12, Bg #FDF5F6)
                    _buildCoachFocusCard(data),
                    SizedBox(height: 20.h),

                    // Today's Doctrine Card (Figma Pad L16 R16 T16 B16, Radius 12, Bg #FDF5F6)
                    _buildDoctrineCard(data),
                    SizedBox(height: 24.h),

                    // Practice Cues Section (Figma Pad L16 R16, Radius 8, Bg #FFFFFF)
                    _buildPracticeCuesList(data),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Button Bar (Figma Pad L120 R120 T16 B16, Radius 16, Text 16)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E5EA), width: 0.8),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: controller.onBeginPractice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC0000),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Begin Practice',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SvgPicture.asset(
                        IconPath.spArrowRight,
                        width: 18.r,
                        height: 18.r,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoBriefCard(dynamic data) {
    return Container(
      width: double.infinity,
      height: 230.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        image: const DecorationImage(
          image: AssetImage(ImagePath.spVideoThumb),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: controller.toggleBriefVideo,
              behavior: HitTestBehavior.opaque,
              child: SvgPicture.asset(
                IconPath.spPlayCircle,
                width: 80.r,
                height: 80.r,
              ),
            ),
          ),
          Positioned(
            left: 18.w,
            right: 18.w,
            bottom: 16.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF040404),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    data.videoTitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD7D7D7),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF040404),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    data.videoDuration,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachFocusCard(dynamic data) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFBE3E1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE5E6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  IconPath.spUser,
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFCC0000),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                data.focusHeader,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0A0A0A),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            data.focusBody,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF555555),
              letterSpacing: -0.5,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctrineCard(dynamic data) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFBE3E1), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE5E6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  IconPath.spTarget,
                  width: 24.r,
                  height: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.doctrine.tag,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: const Color(0xFF555555),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    data.doctrine.title,
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0A0A0A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            data.doctrine.description,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF555555),
              letterSpacing: -0.5,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: controller.toggleDoctrine,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.doctrine.actionLabel,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0A0A0A),
                    ),
                  ),
                  SvgPicture.asset(
                    IconPath.spArrowRight,
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF0A0A0A),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCuesList(dynamic data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cues Header
          Text(
            'PRACTICE CUES',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFCC0000),
            ),
          ),
          SizedBox(height: 14.h),

          // Cue 1: Quick Quick Slow
          _buildCueCard(
            title: 'Quick Quick Slow',
            description:
                'Move through context; slow down on your strongest point.',
            actionText: 'See how to make your strongest words land',
            icon: IconPath.spSound,
          ),
          SizedBox(height: 14.h),

          // Cue 2: First Impression
          _buildCueCard(
            title: 'First Impression',
            description: 'Arrive with warmth and purpose.',
            actionText: 'See how to make your strongest words land',
            icon: IconPath.spUser,
          ),
          SizedBox(height: 14.h),

          // Cue 3: Founder story
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Interview outcomes are usually decided in the first ten to twenty seconds — before a single question is asked. That's energy, not answers. And it starts with genuine warmth toward each person you meet, not a performance for the panel.",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF555555),
                    letterSpacing: -0.5,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'The full founder story follows your practice.',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF555555),
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCueCard({
    required String title,
    required String description,
    required String actionText,
    required String icon,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE5E6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  icon,
                  width: 18.r,
                  height: 18.r,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFCC0000),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF555555),
                        letterSpacing: -0.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    actionText,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0A0A0A),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  IconPath.spArrowRight,
                  width: 14.r,
                  height: 14.r,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFCC0000),
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
