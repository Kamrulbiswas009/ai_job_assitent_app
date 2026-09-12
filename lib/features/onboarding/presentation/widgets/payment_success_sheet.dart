import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../routes/app_routes.dart';
import 'sp_primary_button.dart';

class PaymentSuccessSheet extends StatelessWidget {
  final Map? planArgs;
  final String? txnId;

  const PaymentSuccessSheet({
    super.key,
    this.planArgs,
    this.txnId,
  });

  static Future<void> show({
    BuildContext? context,
    Map? planArgs,
    String? txnId,
  }) {
    if (context != null) {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.transparent,
        builder: (_) => PaymentSuccessSheet(
          planArgs: planArgs,
          txnId: txnId,
        ),
      );
    }
    return Get.bottomSheet(
      PaymentSuccessSheet(
        planArgs: planArgs,
        txnId: txnId,
      ),
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String amount = (planArgs != null && planArgs!['price'] != null)
        ? planArgs!['price'].toString()
        : '£49';
    final String billing =
        (planArgs != null && planArgs!['billingCycle'] != null)
            ? planArgs!['billingCycle'].toString()
            : 'Monthly';
    final String formattedTxn = (txnId != null && txnId!.isNotEmpty)
        ? (txnId!.length > 12
            ? 'TXN-${txnId!.substring(txnId!.length - 6).toUpperCase()}'
            : txnId!)
        : 'TXN-4522';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(32.w, 39.h, 32.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            IconPath.icSuccessCheck,
            width: 112.w,
            height: 112.w,
          ),
          SizedBox(height: 29.h),
          Text(
            'Payment Successful',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Welcome to SpeechPro.Your membership is active',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.pureBlack,
            ),
          ),
          SizedBox(height: 27.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    Text(
                      amount,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                Divider(height: 1.h, color: AppColors.divider),
                SizedBox(height: 11.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction ID',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.purpleSoft,
                        borderRadius: BorderRadius.circular(17.r),
                        border: Border.all(color: AppColors.purple),
                      ),
                      child: Text(
                        formattedTxn,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: AppColors.purple,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Billing',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    Text(
                      billing,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: AppColors.gray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
          SpPrimaryButton(
            label: 'Payment Complete',
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoute.usesOfAi);
            },
          ),
        ],
      ),
    );
  }
}
