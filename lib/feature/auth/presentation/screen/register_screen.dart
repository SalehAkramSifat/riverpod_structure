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
import 'package:practice_riverpod/feature/auth/controller/register/register_controller.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerProvider, (previous, next) {
      if (next.isSuccess) {
        AppSnackBar.showSuccess(next.successMessage);
        context.push(
          AppRoute.otpVerificationScreen,
          extra: {"email": emailController.text.trim(), "isFromRegister": true},
        );
      } else if (next.errorMessage.isNotEmpty) {
        AppSnackBar.showError(next.errorMessage);
      }
    });

    final registerState = ref.watch(registerProvider);
    final controller = ref.read(registerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppbar(
        title: "Create your account",
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    "https://static.vecteezy.com/system/resources/thumbnails/060/199/333/small/minimalist-abstract-3d-curve-in-glowing-green-tone-on-dark-background-elegant-and-modern-visual-for-tech-presentations-ai-projects-website-headers-and-futuristic-graphic-design-templates-vector.jpg",
                    width: double.infinity,
                    height: 110.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 110.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 40.r,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              CustomText(
                text: 'Create Account',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomText(
                text: 'Please fill in the information below to get started',
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.3,
              ),

              SizedBox(height: 24.h),

              CustomText(
                text: 'Full Name',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: "Enter your full name",
                controller: fullNameController,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),

              CustomText(
                text: 'Email Address',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: "Enter your email address",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),

              CustomText(
                text: 'Password',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: "Create a password",
                controller: passwordController,
                isPassword: true,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 16.h),

              CustomText(
                text: 'Confirm Password',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: "Re-enter your password",
                controller: confirmPasswordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
              ),

              SizedBox(height: 32.h),

              CustomButton(
                text: 'Create Account',
                isLoading: registerState.isLoading,
                onTap: () {
                  final email = emailController.text.trim();
                  final name = fullNameController.text.trim();
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (name.isEmpty) {
                    return AppSnackBar.showError("Please Enter your Name");
                  }
                  if (email.isEmpty) {
                    return AppSnackBar.showError("Please Enter your Email");
                  }
                  if (password.isEmpty) {
                    return AppSnackBar.showError("Please Enter your Password");
                  }
                  if (confirmPassword.isEmpty) {
                    return AppSnackBar.showError(
                      "Please Enter your Confirm Password",
                    );
                  }
                  if (password != confirmPassword) {
                    return AppSnackBar.showError("Passwords do not match");
                  }
                  FocusScope.of(context).unfocus();

                  controller.createAccount(
                    email: email,
                    name: name,
                    password: password,
                  );
                },
              ),

              SizedBox(height: 20.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Already have an account? ',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(AppRoute.loginScreen);
                    },
                    child: Text(
                      'Log In',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
