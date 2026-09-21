import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/start_assessment_controller.dart';
import '../widgets/benchmark_scale_selector.dart';
import '../widgets/start_header.dart';

class StartStep3AssessmentScreen extends GetView<StartAssessmentController> {
  const StartStep3AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(currentStep: 3),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'ONE LAST THING',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Before we begin — be honest.',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.5,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Three quick questions. They set your starting benchmark.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // 3 Questions
                    Obx(
                      () => Column(
                        children: controller.benchmarkQuestions
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final q = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 24.h),
                                child: BenchmarkScaleSelector(
                                  question: q.title,
                                  selectedIndex: q.selectedIndex,
                                  onSelected: (optionIndex) {
                                    controller.setBenchmarkAnswer(
                                      index,
                                      optionIndex,
                                    );
                                  },
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Obx(() {
                final isEnabled =
                    controller.isAllAnswered && !controller.isLoading.value;
                return SpPrimaryButton(
                  label: 'Continue',
                  isLoading: controller.isLoading.value,
                  onPressed: isEnabled
                      ? controller.submitAssessmentAndProceed
                      : null,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
