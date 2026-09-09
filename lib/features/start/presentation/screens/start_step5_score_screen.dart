import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/start_controller.dart';
import '../widgets/start_header.dart';

class StartStep5ScoreScreen extends GetView<StartController> {
  const StartStep5ScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(currentStep: 5),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Your Starting Influence Score',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Score 59 / 100 Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Obx(
                          () => Text(
                            '${controller.startingInfluenceScore.value}',
                            style: GoogleFonts.inter(
                              fontSize: 64.sp,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '/100',
                          style: GoogleFonts.inter(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Progress Bar Meter
                    Container(
                      width: 328.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E5EA),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 84.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      "This is your personalized baseline.\nWe'll help you improve it.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    // Training Path Card Container
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFECECEC), width: 1.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 32.r,
                                height: 32.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 18.sp,
                                  color: AppColors.white,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'YOUR TRAINING PATH',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "We've built your first training path around what you told us.",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: const Color(0xFF888888),
                            ),
                          ),
                          SizedBox(height: 14.h),
                          _buildPathRow('PILLAR', 'Power Through Speech', isPrimary: true),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEBEB)),
                          _buildPathRow('FOCUS 1', 'The Voice of Authority.'),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFEBEBEB)),
                          _buildPathRow('FOCUS 2', 'Yi — The Power of Intent'),
                          SizedBox(height: 14.h),
                          Text(
                            "You'll discover why these matter as you train.",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                              color: const Color(0xFF888888),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpPrimaryButton(
                    label: 'Start My First Session',
                    onPressed: controller.finishStartFlow,
                  ),
                  SizedBox(height: 16.h),
                  GestureDetector(
                    onTap: () {},
                    behavior: HitTestBehavior.opaque,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hear why SpeechPro is different',
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          width: 22.r,
                          height: 22.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF1F1),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '▶',
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathRow(String tag, String title, {bool isPrimary = false}) {
    return Container(
      height: 41.h,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            Icons.chevron_right_rounded,
            size: 16.sp,
            color: isPrimary ? AppColors.primary : const Color(0xFF888888),
          ),
          SizedBox(width: 4.w),
          Text(
            tag,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: isPrimary ? AppColors.primary : const Color(0xFF888888),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                height: 1.5,
                color: isPrimary ? AppColors.primary : AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
