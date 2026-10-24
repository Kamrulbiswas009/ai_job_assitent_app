import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/colors.dart';
import 'sp_loading.dart';

class SpPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final BorderSide? side;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? iconSpacing;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const SpPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.height,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.side,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.iconSpacing,
    this.padding,
    this.elevation,
  });

  /// Convenient factory constructor for outlined / secondary buttons
  factory SpPrimaryButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    double? height,
    double? width,
    double? borderRadius,
    Color? borderColor,
    Color? textColor,
    Color? backgroundColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double? iconSpacing,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
  }) {
    final fg = textColor ?? AppColors.pureBlack;
    return SpPrimaryButton(
      key: key,
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      height: height,
      width: width,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      foregroundColor: fg,
      disabledBackgroundColor: AppColors.transparent,
      disabledForegroundColor: fg.withValues(alpha: 0.4),
      side: BorderSide(
        color: borderColor ?? const Color(0xFFE5E5EA),
        width: 1.2,
      ),
      textStyle: textStyle,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      iconSpacing: iconSpacing,
      padding: padding,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? 54.h;
    final effectiveBorderRadius = borderRadius ?? 16.r;
    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final effectiveFgColor = foregroundColor ?? AppColors.white;
    final effectiveDisabledBg = disabledBackgroundColor ??
        (backgroundColor != null && backgroundColor == AppColors.transparent
            ? AppColors.transparent
            : (backgroundColor ?? AppColors.primary).withValues(alpha: 0.5));
    final effectiveDisabledFg = disabledForegroundColor ??
        effectiveFgColor.withValues(alpha: 0.7);

    return SizedBox(
      width: width ?? double.infinity,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBgColor,
          disabledBackgroundColor: effectiveDisabledBg,
          foregroundColor: effectiveFgColor,
          disabledForegroundColor: effectiveDisabledFg,
          elevation: elevation ?? 0,
          shadowColor: AppColors.transparent,
          side: side,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
          alignment: Alignment.center,
        ),
        child: isLoading
            ? const Center(
                child: SpLoading(size: 24),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: iconSpacing ?? 8.w),
                    ],
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle ??
                          GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            letterSpacing: 0.2,
                            color: effectiveFgColor,
                          ),
                    ),
                    if (suffixIcon != null) ...[
                      SizedBox(width: iconSpacing ?? 8.w),
                      suffixIcon!,
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
