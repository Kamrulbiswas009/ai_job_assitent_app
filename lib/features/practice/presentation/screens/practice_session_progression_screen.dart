import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/practice_session_progression_controller.dart';
import '../../model/practice_session_complete_model.dart';

class PracticeSessionProgressionScreen
    extends GetView<PracticeSessionProgressionController> {
  const PracticeSessionProgressionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Obx(() {
          final data = controller.progression.value;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 8.h),
                child: Image.asset(
                  ImagePath.spHeaderLogo,
                  height: 42.h,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR PROGRESSION',
                        style: GoogleFonts.inter(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: AppColors.pureBlack,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _ProgressCard(
                        item: data.doctrine,
                        leading: IconPath.spBook,
                        onTap: controller.recapDoctrine,
                      ),
                      SizedBox(height: 12.h),
                      _ProgressCard(
                        item: data.curriculum,
                        leadingIcon: Icons.school_rounded,
                        onTap: controller.recapModule,
                      ),
                      SizedBox(height: 12.h),
                      _ChapterCard(
                        data: data,
                        onAction: controller.openChapterAction,
                      ),
                      SizedBox(height: 12.h),
                      _ProgressCard(
                        item: data.nextSession,
                        leadingIcon: Icons.calendar_month_rounded,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                child: Column(
                  children: [
                    SpPrimaryButton(
                      label: controller.continueLabel,
                      onPressed: controller.continueToNextSession,
                      height: 54.h,
                      borderRadius: 999.r,
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: OutlinedButton(
                        onPressed: controller.returnHome,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.pureBlack,
                          side: const BorderSide(color: Color(0xFFE5E5EA)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                        ),
                        child: Text(
                          'Return Home',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.pureBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final PracticeProgressionItem item;
  final String? leading;
  final IconData? leadingIcon;
  final VoidCallback? onTap;

  const _ProgressCard({
    required this.item,
    this.leading,
    this.leadingIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = _tone(item.tone);
    return Material(
      color: palette.background,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: palette.iconWell,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: leading != null
                        ? SvgPicture.asset(
                            leading!,
                            width: 18.r,
                            height: 18.r,
                            colorFilter: ColorFilter.mode(
                              palette.accent,
                              BlendMode.srcIn,
                            ),
                          )
                        : Icon(
                            leadingIcon ?? Icons.circle,
                            size: 18.r,
                            color: palette.accent,
                          ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.eyebrow,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF888888),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.pureBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: palette.badgeBackground,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Text(
                      item.badge,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                        color: palette.accent,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                item.body,
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: const Color(0xFF555555),
                ),
              ),
              if (onTap != null) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      item.actionLabel,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16.r,
                      color: AppColors.primary,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20.r,
                      color: const Color(0xFFC7C7CC),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterCard extends StatelessWidget {
  final PracticeSessionProgressionModel data;
  final ValueChanged<PracticeChapterAction> onAction;

  const _ChapterCard({
    required this.data,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7C2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFE09100),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.chapterEyebrow,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    Text(
                      data.chapterTitle,
                      style: GoogleFonts.inter(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.pureBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            data.chapterBody,
            style: GoogleFonts.inter(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF555555),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            data.chapterHint,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF888888),
            ),
          ),
          SizedBox(height: 10.h),
          for (var i = 0; i < data.chapterActions.length; i++) ...[
            _ChapterRow(
              action: data.chapterActions[i],
              onTap: () => onAction(data.chapterActions[i]),
            ),
            if (i < data.chapterActions.length - 1) SizedBox(height: 8.h),
          ],
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  final PracticeChapterAction action;
  final VoidCallback onTap;

  const _ChapterRow({
    required this.action,
    required this.onTap,
  });

  IconData get _icon {
    switch (action.icon) {
      case IconStyle.book:
        return Icons.menu_book_rounded;
      case IconStyle.summary:
        return Icons.article_outlined;
      case IconStyle.headphones:
        return Icons.headphones_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              Icon(_icon, size: 20.r, color: AppColors.primary),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      action.label,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    if (action.subtitle.isNotEmpty)
                      Text(
                        action.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF888888),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.r,
                color: const Color(0xFFC7C7CC),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TonePalette {
  final Color background;
  final Color iconWell;
  final Color badgeBackground;
  final Color accent;

  const _TonePalette({
    required this.background,
    required this.iconWell,
    required this.badgeBackground,
    required this.accent,
  });
}

_TonePalette _tone(String tone) {
  switch (tone) {
    case 'blue':
      return const _TonePalette(
        background: Color(0xFFEEF4FF),
        iconWell: Color(0xFFDCE8FF),
        badgeBackground: Color(0xFFD9E6FF),
        accent: Color(0xFF2F6FED),
      );
    case 'green':
      return const _TonePalette(
        background: Color(0xFFEEF8F1),
        iconWell: Color(0xFFD8F3E0),
        badgeBackground: Color(0xFFD8F3E0),
        accent: Color(0xFF1F9D4A),
      );
    default:
      return const _TonePalette(
        background: AppColors.primarySoft,
        iconWell: AppColors.primaryTint,
        badgeBackground: AppColors.primaryTint,
        accent: AppColors.primary,
      );
  }
}
