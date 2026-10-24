import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/common/widgets/sp_shimmer.dart';
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
        bottom: false,
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpShimmer.box(width: 140.w, height: 28.h, borderRadius: 6.r),
            SizedBox(height: 8.h),
            SpShimmer.box(width: double.infinity, height: 28.h, borderRadius: 6.r),
            SizedBox(height: 6.h),
            SpShimmer.box(width: 220.w, height: 28.h, borderRadius: 6.r),
          ],
        );
      }

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
    });
  }

  Widget _buildDescriptionSection() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpShimmer.box(width: double.infinity, height: 16.h, borderRadius: 4.r),
            SizedBox(height: 6.h),
            SpShimmer.box(width: 240.w, height: 16.h, borderRadius: 4.r),
          ],
        );
      }

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
    });
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final isBusy =
          controller.isLoading.value || controller.isStartingSession.value;
      final buttonLabel = controller.isStartingSession.value
          ? 'Starting Session...'
          : 'Preparing Session...';

      return Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E5EA), width: 0.8),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: SpPrimaryButton(
              label: isBusy ? buttonLabel : 'Enter Session Brief',
              onPressed: isBusy ? null : controller.onEnterSessionBrief,
              isLoading: isBusy,
              height: 56.h,
              borderRadius: 16.r,
              backgroundColor: const Color(0xFFCC0000),
              textStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              suffixIcon: isBusy
                  ? null
                  : SvgPicture.asset(
                      IconPath.spArrowRight,
                      width: 18.r,
                      height: 18.r,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
            ),
          ),
        ),
      );
    });
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
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          width: double.infinity,
          height: 230.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            children: [
              Center(
                child: SpShimmer.circle(size: 72.r),
              ),
              Positioned(
                left: 18.w,
                right: 18.w,
                bottom: 16.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpShimmer.box(width: 140.w, height: 14.h, borderRadius: 4.r),
                    SizedBox(height: 8.h),
                    SpShimmer.box(width: 220.w, height: 18.h, borderRadius: 4.r),
                  ],
                ),
              ),
            ],
          ),
        );
      }

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
    });
  }

  Widget _buildMissionTargetCard() {
    return Obx(() {
      final isLoading = controller.isLoading.value;
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
            if (isLoading) ...[
              SpShimmer.box(width: 180.w, height: 24.h, borderRadius: 6.r),
              SizedBox(height: 8.h),
              SpShimmer.box(width: double.infinity, height: 16.h, borderRadius: 4.r),
              SizedBox(height: 6.h),
              SpShimmer.box(width: 220.w, height: 16.h, borderRadius: 4.r),
            ] else ...[
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
          ],
        ),
      );
    });
  }

  Widget _buildRoleplayOptions() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Column(
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
              ),
              child: Row(
                children: [
                  SpShimmer.box(width: 50.r, height: 50.r, borderRadius: 8.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpShimmer.box(width: 140.w, height: 16.h, borderRadius: 4.r),
                        SizedBox(height: 6.h),
                        SpShimmer.box(
                          width: double.infinity,
                          height: 13.h,
                          borderRadius: 4.r,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  SpShimmer.circle(size: 20.r),
                ],
              ),
            );
          }),
        );
      }

      final roleplays = controller.sessionData.value.roleplays;
      final selectedId = controller.selectedRoleplayId.value;

      return Column(
        children: roleplays.map((roleplay) {
          final isSelected = roleplay.id == selectedId;
          return GestureDetector(
            onTap: () => controller.selectRoleplay(roleplay.id),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: _buildRoleplayAvatar(roleplay, 48.r),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                roleplay.name,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0A0A0A),
                                ),
                              ),
                            ),
                            if (roleplay.isRecommended) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFECEB),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'RECOMMENDED',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFCC0000),
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        isSelected
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 22.sp,
                        color: isSelected
                            ? const Color(0xFFCC0000)
                            : const Color(0xFF8E8E93),
                      ),
                      SizedBox(width: 8.w),
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
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 220),
                    crossFadeState: isSelected
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 1.h,
                            thickness: 1.h,
                            color: const Color(0xFFFBE3E1),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            roleplay.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.4,
                              color: const Color(0xFF444444),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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
            if (controller.isLoading.value) {
              return Column(
                children: List.generate(2, (index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFE5E5EA),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          child: SpShimmer.circle(size: 18.r),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SpShimmer.box(
                                width: 140.w,
                                height: 16.h,
                                borderRadius: 4.r,
                              ),
                              SizedBox(height: 6.h),
                              SpShimmer.box(
                                width: double.infinity,
                                height: 13.h,
                                borderRadius: 4.r,
                              ),
                              SizedBox(height: 4.h),
                              SpShimmer.box(
                                width: 170.w,
                                height: 13.h,
                              borderRadius: 4.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          }

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
