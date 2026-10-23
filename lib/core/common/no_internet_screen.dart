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
    final Widget content = _buildContent(context);

    if (!isFullScreen) {
      return content;
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: showBackButton
          ? AppBar(
              backgroundColor: AppColors.backgroundDark,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.black,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            )
          : null,
      body: SafeArea(child: content),
    );
  }

  Widget _buildContent(BuildContext context) {
    final double animDim = animationSize ?? 300.w;

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
                    size: 96.sp,
                    color: AppColors.backgroundDark,
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),

            CustomText(
              text: title ?? 'No Internet Connection',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
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
                color: AppColors.black,
                textAlign: TextAlign.center,
                height: 1.5,
              ),
            ),
            SizedBox(height: 28.h),

            // Action / Retry Button
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
