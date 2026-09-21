import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants/colors.dart';

class CustomCardTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? initialValue;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderWidth;
  final double focusedBorderWidth;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;

  const CustomCardTextField({
    super.key,
    this.controller,
    this.hintText,
    this.initialValue,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 1.5,
    this.backgroundColor,
    this.padding,
    this.maxLines = 4,
    this.minLines = 3,
    this.style,
    this.hintStyle,
    this.onChanged,
    this.readOnly = false,
    this.keyboardType,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = BorderRadius.circular(borderRadius ?? 16.r);

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      keyboardType: keyboardType ?? TextInputType.multiline,
      focusNode: focusNode,
      onChanged: onChanged,
      style:
          style ??
          GoogleFonts.inter(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: AppColors.black,
          ),
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? AppColors.white,
        contentPadding: padding ?? EdgeInsets.all(16.w),
        hintText: hintText,
        hintStyle:
            hintStyle ??
            GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: const Color(0xFF888888),
            ),
        enabledBorder: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(
            color: borderColor ?? const Color(0xFFE5E5EA),
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.primary,
            width: focusedBorderWidth,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: effectiveRadius,
          borderSide: BorderSide(
            color: borderColor ?? const Color(0xFFE5E5EA),
            width: borderWidth,
          ),
        ),
      ),
    );
  }
}
