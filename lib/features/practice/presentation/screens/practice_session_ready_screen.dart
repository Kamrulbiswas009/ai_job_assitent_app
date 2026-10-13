import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/practice_session_ready_controller.dart';
import '../../model/practice_session_ready_model.dart';
import '../widgets/practice_scaffold.dart';

class PracticeSessionReadyScreen
    extends GetView<PracticeSessionReadyController> {
  const PracticeSessionReadyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PracticeScaffold(
      isRoot: true,
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(),
                      SizedBox(height: 8.h),
                      _buildDescriptionSection(),
                    SizedBox(height: 24.h),

                    // Founder Insight Video Card (Figma Radius 12)
                    _buildVideoInsightCard(),
                    SizedBox(height: 24.h),

                    // Mission Target Card (Figma Pad L16 R16 T16 B16, Radius 12, Bg #FDF5F6)
                    _buildMissionTargetCard(),
                    SizedBox(height: 24.h),

                    // Roleplay Selection: Header Size 20, Weight 700, Color #0A0A0A
                    Text(
                      'Who should SpeechPro roleplay for this session?',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0A0A0A),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    _buildRoleplayOptions(),
                    SizedBox(height: 12.h),

                    // Selected Roleplay Highlight Banner (Figma Radius 12)
                    _buildSelectedRoleplayBanner(),
                    SizedBox(height: 12.h),

                    // Roleplay Info Notice (Figma Bg #F9F8F8, Radius 12, Pad 16, Text Size 16)
                    _buildInfoNotice(
                      'You can change the roleplay character at any time in future sessions.',
                    ),
                    SizedBox(height: 24.h),

                    // Challenge Mode Section (Figma ItemSp 12, Radius 12)
                    _buildChallengeModeSection(),
                    SizedBox(height: 12.h),

                    // XP Info Notice (Figma Bg #F9F8F8, Radius 12, Pad 16, Text Size 16)
                    _buildInfoNotice(
                      'XP means experience points you earn through practice.',
                    ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeaderSection() {
    final data = controller.sessionData.value;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${data.userName}, ',
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE60008),
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          TextSpan(
            text: data.heading,
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0A0A0A),
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Text(
      controller.sessionData.value.description,
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF666666),
        height: 1.4,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
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
          onPressed: controller.isLoading.value
              ? null
              : controller.onEnterSessionBrief,
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
                'Enter Session Brief',
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
    );
  }

  Widget _buildRoleplayAvatar(RoleplayOptionModel roleplay, double size) {
    final url = roleplay.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          roleplay.imageAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    return Image.asset(
      roleplay.imageAsset,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }

  Widget _buildVideoInsightCard() {
    final data = controller.sessionData.value;
    final thumbnailUrl = data.founderInsightThumbnailUrl;

    return Container(
      width: double.infinity,
      height: 230.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: thumbnailUrl != null && thumbnailUrl.isNotEmpty
              ? NetworkImage(thumbnailUrl)
              : const AssetImage(ImagePath.spVideoThumb),
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
              onTap: controller.toggleFounderInsightVideo,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCC0000),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      data.founderInsightTag,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFD7D7D7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  data.founderInsightTitle,
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE8E8E8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionTargetCard() {
    final data = controller.sessionData.value;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFBE3E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconPath.spTarget,
                width: 24.r,
                height: 24.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'MISSION TARGET',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: const Color(0xFF555555),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            data.missionTarget,
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '"${data.missionTargetQuote}"',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF555555),
              height: 1.4,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleplayOptions() {
    return Obx(() {
      final roleplays = controller.sessionData.value.roleplays;
      final selectedId = controller.selectedRoleplayId.value;

      return Column(
        children: roleplays.map((roleplay) {
          final isSelected = roleplay.id == selectedId;
          return GestureDetector(
            onTap: () => controller.selectRoleplay(roleplay.id),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFDF5F6)
                    : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFCC0000)
                      : const Color(0xFFE5E5EA),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: _buildRoleplayAvatar(roleplay, 50.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          roleplay.name,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0A0A0A),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          roleplay.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                            color: const Color(0xFF555555),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 20.r,
                    height: 20.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFCC0000)
                            : const Color(0xFFC7C7CC),
                        width: isSelected ? 5.5 : 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildSelectedRoleplayBanner() {
    return Obx(() {
      final roleplay = controller.selectedRoleplay;
      if (roleplay == null) return const SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF5F6),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFBE3E1), width: 1.2),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildRoleplayAvatar(roleplay, 46.r),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 14.sp,
                        color: const Color(0xFFCC0000),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'SELECTED ROLEPLAY',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    roleplay.name,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0A0A0A),
                    ),
                  ),
                  Text(
                    roleplay.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
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
    });
  }

  Widget _buildChallengeModeSection() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF5F6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFBE3E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                IconPath.spFlash,
                width: 20.r,
                height: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'CHALLENGE MODE',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE60008),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Recreates real-world adversarial pressure. SpeechPro may interrupt, challenge assumptions, and hold deliberate silences.',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF555555),
              letterSpacing: -0.5,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() {
            final modes = controller.sessionData.value.challengeModes;
            final selectedId = controller.selectedChallengeModeId.value;

            return Column(
              children: modes.map((mode) {
                final isSelected = mode.id == selectedId;
                return GestureDetector(
                  onTap: () => controller.selectChallengeMode(mode.id),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFDF5F6)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFCC0000)
                            : const Color(0xFFE5E5EA),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          width: 18.r,
                          height: 18.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFCC0000)
                                  : const Color(0xFFC7C7CC),
                              width: isSelected ? 5.0 : 1.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mode.title,
                                style: GoogleFonts.inter(
                                  fontSize: mode.isXpBonus ? 18.sp : 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0A0A0A),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                mode.description,
                                style: GoogleFonts.inter(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF555555),
                                  letterSpacing: -0.5,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInfoNotice(String message) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconPath.spAlert,
            width: 20.r,
            height: 20.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF555555),
                letterSpacing: -0.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
