import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/icon_path.dart';
import '../../../../core/utils/constants/image_path.dart';

class PracticeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isRoot;
  final VoidCallback? onLeadingTap;

  const PracticeAppBar({
    super.key,
    this.isRoot = false,
    this.onLeadingTap,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading: Menu or Back
            GestureDetector(
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

            // Center Logo Wordmark (Exact Figma Asset)
            Image.asset(
              ImagePath.spHeaderLogo,
              height: 44.h,
              fit: BoxFit.contain,
            ),

            // Trailing: User profile circle (Exact Figma Asset)
            Container(
              width: 38.r,
              height: 38.r,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F7F7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                IconPath.spUser,
                width: 18.r,
                height: 18.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
