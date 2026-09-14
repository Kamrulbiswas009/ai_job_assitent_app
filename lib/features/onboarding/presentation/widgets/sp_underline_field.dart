import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';

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
    final hintSize = (widget.hintFontSize ?? 14.5).toDouble().sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            height: 1.4,
            color: AppColors.pureBlack,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          style: GoogleFonts.inter(
            fontSize: hintSize,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: AppColors.pureBlack,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: hintSize,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: const Color(0xFFB0B7C3),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.0),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.0),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding: EdgeInsets.only(bottom: 8.h, top: 2.h),
            suffixIcon: widget.showObscureToggle
                ? GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: _obscure
                          ? SvgPicture.asset(
                              IconPath.icEyeSlash,
                              width: 20.w,
                              height: 20.w,
                            )
                          : Icon(
                              Icons.visibility_outlined,
                              size: 20.w,
                              color: const Color(0xFFB8BFCA),
                            ),
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
