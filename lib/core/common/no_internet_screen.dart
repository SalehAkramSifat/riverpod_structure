import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:riverpod_structure/core/common/custom_button.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_animations.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final bool isRetrying;
  final String? title;
  final String? message;
  final String buttonText;
  final bool isFullScreen;
  final bool showBackButton;
  final double? animationSize;

  const NoInternetScreen({
    super.key,
    this.onRetry,
    this.isRetrying = false,
    this.title,
    this.message,
    this.buttonText = 'Try Again',
    this.isFullScreen = true,
    this.showBackButton = false,
    this.animationSize,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? AppColors.backgroundDark : AppColors.white;
    final Widget content = _buildContent(context, isDark);

    if (!isFullScreen) {
      return Container(color: bgColor, child: content);
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: showBackButton
          ? AppBar(
              backgroundColor: bgColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            )
          : null,
      body: SafeArea(child: content),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    final double animDim = animationSize ?? 260.w;
    final Color textColor = isDark ? AppColors.white : AppColors.black;
    final Color subTextColor = isDark
        ? AppColors.white.withValues(alpha: 0.6)
        : AppColors.secondaryLight;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: animDim,
              height: animDim,
              child: Lottie.asset(
                AppAnimations.noInternet,
                fit: BoxFit.contain,
                repeat: true,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.wifi_off_rounded,
                    size: 80.sp,
                    color: isDark
                        ? AppColors.secondaryLight
                        : AppColors.primaryLight,
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),

            CustomText(
              text: title ?? 'No Internet Connection',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomText(
                text:
                    message ??
                    'Please check your Wi-Fi or mobile data connection and try again.',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: subTextColor,
                textAlign: TextAlign.center,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28.h),

            if (onRetry != null)
              CustomButton(
                text: buttonText,
                isLoading: isRetrying,
                prefixIcon: isRetrying
                    ? null
                    : Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: AppColors.white,
                          size: 18.sp,
                        ),
                      ),
                onTap: isRetrying ? null : onRetry,
              ),
          ],
        ),
      ),
    );
  }
}
