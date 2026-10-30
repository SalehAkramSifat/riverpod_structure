import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_riverpod/core/common/app_snackbar.dart';
import 'package:practice_riverpod/core/common/custom_appbar.dart';
import 'package:practice_riverpod/core/common/custom_button.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/common/custom_textformfield.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';
import 'package:practice_riverpod/feature/auth/controller/reset/reset_password_controller.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;
  final String? otp;

  const ResetPasswordScreen({super.key, this.email, this.otp});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetProvider, (previous, next) {
      if (next.isLoading == true) return;
      if (next.isSuccess == true) {
        AppSnackBar.showSuccess('Password reset successfully!');
        context.go(AppRoute.homeScreen);
      } else {
        AppSnackBar.showSuccess(next.errorMessage);
      }
    });
    final screenState = ref.watch(resetProvider);
    final notifier = ref.read(resetProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    'https://static.vecteezy.com/system/resources/thumbnails/060/199/333/small/minimalist-abstract-3d-curve-in-glowing-green-tone-on-dark-background-elegant-and-modern-visual-for-tech-presentations-ai-projects-website-headers-and-futuristic-graphic-design-templates-vector.jpg',
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: 48.r,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Title and Subtitle
              CustomText(
                text: 'Reset Password',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text:
                    'Your new password must be unique and different from previously used passwords.',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),

              SizedBox(height: 32.h),

              CustomText(
                text: 'New Password',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: 'Enter your new password',
                controller: newPasswordController,
                isPassword: true,
                textInputAction: TextInputAction.next,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 18.h),

              // Confirm Password Field
              CustomText(
                text: 'Confirm Password',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: 'Re-enter your new password',
                controller: confirmPasswordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 28.h),

              // Reset Password Button
              CustomButton(
                text: 'Reset Password',
                isLoading: screenState.isLoading == true,
                onTap: () {
                  final newPassword = newPasswordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (newPassword.isEmpty) {
                    AppSnackBar.showError('Please enter your new password');
                    return;
                  }
                  if (newPassword.length < 6) {
                    AppSnackBar.showError(
                      'Password must be at least 6 characters',
                    );
                    return;
                  }
                  if (confirmPassword.isEmpty) {
                    AppSnackBar.showError('Please confirm your new password');
                    return;
                  }
                  if (newPassword != confirmPassword) {
                    AppSnackBar.showError('Passwords do not match');
                    return;
                  }

                  notifier.resetPassword(password: newPassword);
                },
              ),

              SizedBox(height: 32.h),

              Center(
                child: GestureDetector(
                  onTap: () {
                    context.go(AppRoute.loginScreen);
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Remember your password? '),
                        TextSpan(
                          text: 'Log in',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
