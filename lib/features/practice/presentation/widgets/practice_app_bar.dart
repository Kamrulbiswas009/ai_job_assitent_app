import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';

class PracticeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isRoot;
  final VoidCallback? onLeadingTap;
  final VoidCallback? onProfileTap;

  const PracticeAppBar({
    super.key,
    this.isRoot = false,
    this.onLeadingTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center Logo Wordmark (Exact Figma Asset)
            Center(
              child: Image.asset(
                ImagePath.spHeaderLogo,
                height: 80.h,
                fit: BoxFit.contain,
              ),
            ),

            // Leading: Menu or Back (Pinned to Left)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onLeadingTap ?? (isRoot ? () {} : () => Get.back()),
                behavior: HitTestBehavior.opaque,
                child: isRoot
                    ? SizedBox(
                        width: 38.r,
                        height: 38.r,
                        child: Center(
                          child: SvgPicture.asset(
                            IconPath.spMenu,
                            width: 24.r,
                            height: 24.r,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 38.r,
                        height: 38.r,
                        child: Center(
                          child: SvgPicture.asset(
                            IconPath.spArrowLeft,
                            width: 24.r,
                            height: 24.r,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
