import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/common/widgets/sp_primary_button.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../controller/practice_menu_controller.dart';

class PracticeSideMenu extends GetView<PracticeMenuController> {
  const PracticeSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    controller.refreshProfile();

    return Drawer(
      width: 320.w,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0A0A0A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, size: 24.r),
                    color: const Color(0xFF555555),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(() => _ProfileHeader(
                    initials: controller.initials,
                    name: controller.fullName.value,
                    bio: controller.bio.value,
                  )),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(() => _SideMenuTabs(
                    selectedIndex: controller.selectedTab.value,
                    onSelect: controller.selectTab,
                  )),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() {
                  if (controller.selectedTab.value == 0) {
                    return _BioTab(bio: controller.bio.value);
                  }
                  return _ProfileDetailsTab(
                    fullName: controller.fullName.value,
                    email: controller.email.value,
                    userId: controller.userId.value,
                    isSubscribed: controller.isSubscribed.value,
                  );
                }),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: Obx(() {
                final isLoggingOut = controller.isLoggingOut.value;
                return SpPrimaryButton.outlined(
                  label: isLoggingOut ? 'Signing out...' : 'Log out',
                  onPressed: isLoggingOut
                      ? null
                      : () async {
                          Navigator.of(context).pop();
                          await controller.logout();
                        },
                  isLoading: isLoggingOut,
                  height: 52.h,
                  borderRadius: 14.r,
                  borderColor: const Color(0xFFCC0000),
                  textColor: const Color(0xFFCC0000),
                  prefixIcon: isLoggingOut
                      ? null
                      : SvgPicture.asset(
                          IconPath.spUser,
                          width: 18.r,
                          height: 18.r,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFCC0000),
                            BlendMode.srcIn,
                          ),
                        ),
                  textStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFCC0000),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String initials;
  final String name;
  final String bio;

  const _ProfileHeader({
    required this.initials,
    required this.name,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88.r,
          height: 88.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFCC0000), Color(0xFFE60008)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCC0000).withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          name,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0A0A0A),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          bio,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _SideMenuTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _SideMenuTabs({
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _tabButton(label: 'Bio', index: 0),
          _tabButton(label: 'Profile', index: 1),
        ],
      ),
    );
  }

  Expanded _tabButton({required String label, required int index}) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onSelect(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF0A0A0A)
                    : const Color(0xFF666666),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BioTab extends StatelessWidget {
  final String bio;

  const _BioTab({required this.bio});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF5F6),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFFBE3E1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About you',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0A0A0A),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              bio,
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF555555),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileDetailsTab extends StatelessWidget {
  final String fullName;
  final String email;
  final String userId;
  final bool isSubscribed;

  const _ProfileDetailsTab({
    required this.fullName,
    required this.email,
    required this.userId,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F8F8),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            _detailRow('Full name', fullName),
            _divider(),
            _detailRow('Email', email),
            _divider(),
            _detailRow('User ID', userId),
            _divider(),
            _detailRow(
              'Membership',
              isSubscribed ? 'Active subscriber' : 'Free member',
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: const Divider(height: 1, color: Color(0xFFE5E5EA)),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF666666),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0A0A0A),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
