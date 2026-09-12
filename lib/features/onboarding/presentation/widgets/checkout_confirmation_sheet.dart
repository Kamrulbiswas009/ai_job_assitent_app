import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/constants/colors.dart';
import '../../controller/onboarding_controller.dart';
import '../../model/membership_plan_model.dart';
import 'payment_success_sheet.dart';
import 'sp_primary_button.dart';

class CheckoutConfirmationSheet extends StatelessWidget {
  final MembershipPlanModel plan;

  const CheckoutConfirmationSheet({
    super.key,
    required this.plan,
  });

  static Future<void> show(
    BuildContext context, {
    required MembershipPlanModel plan,
  }) {
    Get.find<OnboardingController>().resetCheckoutState();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => CheckoutConfirmationSheet(plan: plan),
    );
  }

  void _handlePaymentDone() {
    Get.back(); // close confirmation sheet
    PaymentSuccessSheet.show(
      planArgs: plan.toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.find<OnboardingController>();

    return Obx(
      () => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              controller.isPaymentLaunched.value
                  ? 'Complete Payment in Stripe'
                  : 'Confirm Your Training Plan',
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              controller.isPaymentLaunched.value
                  ? 'Stripe checkout has opened in your browser. After finishing your payment, tap the button below.'
                  : 'You are about to start your SpeechPro membership with the following details:',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.gray,
                height: 1.4,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan.title,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          plan.billingCycle,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        plan.price,
                        style: GoogleFonts.inter(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        plan.period,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    plan.billingText,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 18.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    controller.isPaymentLaunched.value
                        ? Icons.check_circle_outline_rounded
                        : Icons.lock_outline_rounded,
                    size: 18.sp,
                    color: controller.isPaymentLaunched.value
                        ? AppColors.primary
                        : AppColors.gray,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      controller.isPaymentLaunched.value
                          ? 'Once you complete your payment on Stripe, tap "Payment Completed" to activate your plan.'
                          : 'You will be redirected to the secure Stripe checkout page to complete your payment.',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF555555),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (!controller.isPaymentLaunched.value) ...[
              SpPrimaryButton(
                label: 'Proceed to Payment',
                isLoading: controller.isCheckoutLoading.value,
                onPressed: controller.isCheckoutLoading.value
                    ? null
                    : () => controller.handleProceedToPayment(plan.planId),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray,
                    ),
                  ),
                ),
              ),
            ] else ...[
              SpPrimaryButton(
                label: 'Payment Completed',
                onPressed: _handlePaymentDone,
              ),
              SizedBox(height: 10.h),
              if (controller.checkoutUrl.value.isNotEmpty) ...[
                SizedBox(
                  width: double.infinity,
                  height: 44.h,
                  child: TextButton.icon(
                    icon: Icon(
                      Icons.open_in_new_rounded,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      'Reopen Stripe Checkout',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    onPressed: () => controller
                        .launchCheckoutUrl(controller.checkoutUrl.value),
                  ),
                ),
              ],
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
