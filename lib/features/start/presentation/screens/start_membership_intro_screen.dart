import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controller/start_membership_controller.dart';

class StartMembershipIntroScreen extends GetView<StartMembershipController> {
  const StartMembershipIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadUserData();

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
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Column(
                      children: [
                        const Spacer(flex: 3),
                        // Confetti Icon
                        Center(
                          child: Image.asset(
                            ImagePath.confetti,
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 28.h),
                        // Main Heading
                        Obx(
                          () {
                            final rawName = controller.userFirstName.value.trim();
                            final firstName = rawName.isNotEmpty
                                ? '${rawName[0].toUpperCase()}${rawName.substring(1)}'
                                : (controller.userName.value.trim().isNotEmpty
                                    ? controller.userName.value.trim().split(' ').first
                                    : '');
                            return Text(
                              firstName.isNotEmpty
                                  ? 'Great news, $firstName !'
                                  : 'Great news !',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                                color: AppColors.pureBlack,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your SpeechPro membership has started',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15.5.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        // Unified 3-Pillar Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBEFEA),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              _buildPillarRow(
                                IconPath.icFire,
                                'Power Through Speech',
                              ),
                              const Divider(
                                height: 1,
                                thickness: 0.8,
                                color: Color(0x14000000),
                              ),
                              _buildPillarRow(
                                IconPath.icBoltColor,
                                'Influence Through Impact',
                              ),
                              const Divider(
                                height: 1,
                                thickness: 0.8,
                                color: Color(0x14000000),
                              ),
                              _buildPillarRow(
                                IconPath.icCrownColor,
                                'Authority Through Presence',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Description text below card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Text(
                            'You now have access to thirty years of real world experience, from a top growth and communication expert, built into a system you can train with anytime.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.45,
                              color: const Color(0xFF8E8E93),
                            ),
                          ),
                        ),
                        const Spacer(flex: 4),
                        SpPrimaryButton(
                          label: 'What do you want to achieve',
                          onPressed: controller.goToStep1,
                        ),
                        SizedBox(height: 24.h),
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

  Widget _buildPillarRow(String iconPath, String title) {
    return Container(
      height: 52.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(width: 2.w),
          Image.asset(iconPath, width: 22.w, height: 22.w, fit: BoxFit.contain),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: AppColors.pureBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
