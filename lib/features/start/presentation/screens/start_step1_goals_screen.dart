import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/start_controller.dart';
import '../widgets/goal_item_tile.dart';
import '../widgets/start_header.dart';

class StartStep1GoalsScreen extends GetView<StartController> {
  const StartStep1GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const StartHeader(currentStep: 1),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Obx(
                      () => Text(
                        'Hey ${controller.userName.value}, you\'re in the right place, this is where we make it happen.',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'What do you want to achieve?',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Choose what matters most to you right now — or describe it in your own words below.',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: const Color(0xFF888888),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Goals List
                    Obx(
                      () => Column(
                        children: controller.goalCategories.map((goal) {
                          final isSelected =
                              controller.selectedGoalId.value == goal.id;
                          return GoalItemTile(
                            number: goal.number,
                            title: goal.title,
                            isSelected: isSelected,
                            onTap: () => controller.selectGoal(goal),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: SpPrimaryButton(
                label: 'Continue',
                onPressed: controller.goToStep2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
