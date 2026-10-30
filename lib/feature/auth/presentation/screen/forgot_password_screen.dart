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
import 'package:practice_riverpod/feature/auth/controller/forgot/forgot_password_controller.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(forgotProvider, (previous, next) {
      if (next.isSuccess) {
        AppSnackBar.showSuccess("Please check your email.");
        context.push(
          AppRoute.otpVerificationScreen,
          extra: emailController.text.trim(),
        );
      } else if (next.errorMessage.isNotEmpty) {
        AppSnackBar.showError(next.errorMessage);
      }
    });

    final forgotState = ref.watch(forgotProvider);
    final forgotController = ref.read(forgotProvider.notifier);

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
                text: 'Forgot Password?',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              SizedBox(height: 8.h),
              CustomText(
                text:
                    "Don't worry! Please enter the email address linked with your account to receive a reset link.",
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),

              SizedBox(height: 32.h),

              CustomText(
                text: 'Email Address',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: 'Please enter your email address',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(
                  Icons.mail_outline_rounded,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 24.h),

              CustomButton(
                text: 'Send',
                isLoading: forgotState.isLoading,
                onTap: () {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    AppSnackBar.showError("Please enter your email first");
                    return;
                  }
                  forgotController.forgotPassword(email: email);
                },
              ),

              SizedBox(height: 32.h),

              Center(
                child: GestureDetector(
                  onTap: () {
                    context.pop();
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
