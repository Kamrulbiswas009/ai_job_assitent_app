import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/saved_session_model.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

class ContinueSessionDialog extends StatelessWidget {
  final SavedSessionModel session;

  const ContinueSessionDialog({
    super.key,
    required this.session,
  });

  /// Displays the dialog smoothly and returns `true` (continue) or `false` (start fresh)
  static Future<bool?> show(
    BuildContext context, {
    required SavedSessionModel session,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ContinueSessionDialog',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return ContinueSessionDialog(session: session);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Container(
        constraints: BoxConstraints(maxWidth: 380.w),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 18.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Badge Icon with Brand Soft Tint
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryTint, width: 2),
                ),
                child: Center(
                  child: Icon(
                    Icons.history_rounded,
                    size: 26.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 14.h),

              // Dialog Title
              Text(
                'Continue Previous Session?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18.5.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.pureBlack,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 6.h),

              // Dialog Description
              Text(
                'You have an active session from your last visit. Would you like to resume where you left off or start fresh?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF555555),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 14.h),

              // Session Highlight Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9FB),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFFEBEBEF), width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34.r,
                      height: 34.r,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SAVED PROGRESS',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            session.title,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),

              // Primary Brand Action: Yes, Continue
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Yes, Continue Session',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          IconPath.spArrowRight,
                          width: 16.r,
                          height: 16.r,
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
              SizedBox(height: 10.h),

              // Secondary Action: No, Start Fresh
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E5EA), width: 1.2),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'No, Start Fresh',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
