import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/onboarding_assets.dart';
import '../constants/onboarding_colors.dart';

class SpUnderlineField extends StatefulWidget {
  const SpUnderlineField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.keyboardType,
    this.hintFontSize,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final bool showObscureToggle;
  final TextInputType? keyboardType;
  final num? hintFontSize;

  @override
  State<SpUnderlineField> createState() => _SpUnderlineFieldState();
}

class _SpUnderlineFieldState extends State<SpUnderlineField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final hintSize = (widget.hintFontSize ?? 16).toDouble().sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.5,
            color: OnboardingColors.pureBlack,
          ),
        ),
        SizedBox(height: 15.h),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.inter(
            fontSize: hintSize,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: OnboardingColors.black,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: hintSize,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: OnboardingColors.placeholder,
            ),
            border: InputBorder.none,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: OnboardingColors.divider, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: OnboardingColors.primary, width: 1),
            ),
            contentPadding: EdgeInsets.only(bottom: 10.h),
            suffixIcon: widget.showObscureToggle
                ? IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 20.w, minHeight: 20.h),
                    icon: SvgPicture.asset(
                      OnboardingAssets.icEyeSlash,
                      width: 20.w,
                      height: 20.h,
                    ),
                  )
                : null,
            suffixIconConstraints: BoxConstraints(
              minWidth: 20.w,
              minHeight: 20.h,
            ),
          ),
        ),
      ],
    );
  }
}
