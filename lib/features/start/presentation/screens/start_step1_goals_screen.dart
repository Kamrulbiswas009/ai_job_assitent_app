import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../controller/start_goals_controller.dart';
import '../widgets/goal_item_tile.dart';
import '../widgets/start_header.dart';

class StartStep1GoalsScreen extends GetView<StartGoalsController> {
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
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Obx(
                      () => Text(
                        "Hey ${controller.userName.value},\nyou're in the right place,\nthis is where we make it happen.",
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: AppColors.pureBlack,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'What do you want to achieve?',
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        color: AppColors.pureBlack,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Choose what matters most to you right now — or describe it in your own words below.',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                        color: const Color.fromARGB(255, 21, 21, 21),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const _AccentDivider(),
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
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
              child: SpPrimaryButton(
                label: 'Continue',
                onPressed: controller.submitGoalAndProceed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentDivider extends StatelessWidget {
  const _AccentDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomPaint(size: Size(8.w, 9.h), painter: _TrianglePainter()),
        Expanded(
          child: Container(height: 0.8.h, color: const Color(0xFFF0F0F2)),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
