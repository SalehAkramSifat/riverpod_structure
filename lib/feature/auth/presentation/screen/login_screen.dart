import 'package:flutter/gestures.dart';
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
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';
import 'package:practice_riverpod/feature/auth/controller/login/login_controller.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previous, next) {
      if (next.isSuccess) {
        context.push(AppRoute.homeScreen);
      } else if (next.isNotVerifed) {
        AppSnackBar.showError("Your are not verfied please verfiy yourself");
      } else if (next.errorMessage != null) {
        AppSnackBar.showError(next.errorMessage!);
      }
    });
    final loginState = ref.watch(loginProvider);
    final loginController = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppbar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CustomText(
                      text: 'Log in or Sign up!',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),
                    CustomText(
                      text:
                          'Your path towards flexible job placement with ease.',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              CustomText(
                text: 'Email Address',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: "Please Enter your email Address",
                controller: emailController,
              ),
              SizedBox(height: 12.h),
              CustomText(
                text: 'Password',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              SizedBox(height: 6.h),
              CustomTextFormField(
                hintText: "Please Enter your Password",
                controller: phoneController,
                isPassword: true,
              ),
              SizedBox(height: 6.h),

              GestureDetector(
                onTap: () {
                  context.push(AppRoute.forgotPasswordScreen);
                },
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: CustomText(
                    text: "Forgot password?",
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              CustomButton(
                text: 'Continue',
                isLoading: loginState.isLoading,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final phone = phoneController.text.trim();
                  final email = emailController.text.trim();
                  if (phone.isEmpty) {
                    return AppSnackBar.showError(
                      "Please Enter phone number first.",
                    );
                  }
                  if (email.isEmpty) {
                    return AppSnackBar.showError(
                      "Please Enter Email number first.",
                    );
                  }
                  await loginController.login(email: email, password: phone);
                },
              ),
              SizedBox(height: 32.h),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextSpan(
                        text: "Sign up",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push(AppRoute.registerScreen);
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'Explore our '),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: '.'),
                    ],
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
