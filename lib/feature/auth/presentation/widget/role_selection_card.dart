import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';

class RoleSelectionCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final VoidCallback? onTap;

  const RoleSelectionCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardSelectedBg : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected
              ? null
              : Border.all(color: AppColors.cardBorder, width: 1.5.w),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24.sp,
              height: 24.sp,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.white : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                height: 1.2,
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.circle_outlined,
              size: 24.sp,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
