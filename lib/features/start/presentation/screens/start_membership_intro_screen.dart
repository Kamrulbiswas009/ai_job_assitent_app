import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/start_membership_controller.dart';

class StartMembershipIntroScreen extends GetView<StartMembershipController> {
  const StartMembershipIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        const Spacer(flex: 3),
                        // Confetti Icon
                        Center(
                          child: Image.asset(
                            ImagePath.confetti,
                            width: 88.w,
                            height: 88.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Main Heading
                        Obx(
                          () => Text(
                            'Great news, ${controller.userFirstName.value} !',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              color: AppColors.pureBlack,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your SpechPro membership has started',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 36.h),
                        // Unified 3-Pillar Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF1EC),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              _buildPillarRow('1', 'Power Through Speech'),
                              const Divider(
                                height: 1,
                                thickness: 0.8,
                                color: Color(0x14000000),
                              ),
                              _buildPillarRow('2', 'Influence Through Impact'),
                              const Divider(
                                height: 1,
                                thickness: 0.8,
                                color: Color(0x14000000),
                              ),
                              _buildPillarRow(
                                '3',
                                'Authority Through Presence',
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 4),
                        // Footer CTA
                        Text(
                          'Now let’s find out what you want to achieve.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF71717A),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SpPrimaryButton(
                          label: 'What do you want to achieve',
                          onPressed: controller.goToStep1,
                        ),
                        SizedBox(height: 36.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPillarRow(String number, String title) {
    return Container(
      height: 52.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(3.r),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                height: 1.1,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.4,
                color: AppColors.pureBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
