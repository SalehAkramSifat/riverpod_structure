import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';
import 'package:riverpod_structure/routes/app_router.dart';

class AppSnackBar {
  AppSnackBar._();

  static void showError(
    String message, {
    BuildContext? context,
    String title = 'Error',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      message: message,
      context: context,
      title: title,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
      duration: duration,
    );
  }

  static void showSuccess(
    String message, {
    BuildContext? context,
    String title = 'Success',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      message: message,
      context: context,
      title: title,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
      duration: duration,
    );
  }

  static void _show({
    required String message,
    BuildContext? context,
    required String title,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final targetContext = context ?? rootNavigatorKey.currentContext;
    if (targetContext == null) return;

    final messenger = ScaffoldMessenger.maybeOf(targetContext);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(12.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 28.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    SizedBox(height: 2.h),
                    CustomText(
                      text: message,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                      maxLines: 3,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
