import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/onboarding_assets.dart';
import '../constants/onboarding_colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/payment_success_sheet.dart';
import '../widgets/sp_primary_button.dart';
import '../widgets/sp_underline_field.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const String routeName = '/checkout';

  void _showPaymentSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PaymentSuccessSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const OnboardingHeader(style: OnboardingHeaderStyle.backOnly),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 15.h, bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Details',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: OnboardingColors.gray,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Secure Checkout',
                        style: GoogleFonts.inter(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: OnboardingColors.black,
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Divider(
                        height: 1.h,
                        thickness: 1,
                        color: OnboardingColors.divider,
                      ),
                      SizedBox(height: 26.h),
                      _CreditCardPreview(),
                      SizedBox(height: 29.h),
                      SpUnderlineField(
                        label: 'Card Number',
                        hint: '0000 0000 0000 0000',
                        hintFontSize: 12,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        children: [
                          Expanded(
                            child: SpUnderlineField(
                              label: 'Expiry',
                              hint: 'mm/yy',
                              hintFontSize: 12,
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: SpUnderlineField(
                              label: 'CVV',
                              hint: '•••',
                              hintFontSize: 12,
                              obscureText: true,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      SpUnderlineField(
                        label: 'Name on card',
                        hint: 'Aycan Doganlar',
                        hintFontSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
              SpPrimaryButton(
                label: 'Pay Now',
                onPressed: () => _showPaymentSuccess(context),
              ),
              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditCardPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 213.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(13.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.w, 33.h, 30.w, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        OnboardingAssets.icEmvChip,
                        width: 44.w,
                        height: 30.h,
                      ),
                      SvgPicture.asset(
                        OnboardingAssets.icMastercard,
                        width: 42.w,
                        height: 26.h,
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '••••  ••••  ••••  3282',
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(13.r),
                bottomRight: Radius.circular(13.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Card Holder',
                      style: GoogleFonts.dmSans(
                        fontSize: 10.sp,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'Aycan Doganlar',
                      style: GoogleFonts.dmSans(
                        fontSize: 13.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Expires',
                      style: GoogleFonts.dmSans(
                        fontSize: 10.sp,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      '12/23',
                      style: GoogleFonts.dmSans(
                        fontSize: 13.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
