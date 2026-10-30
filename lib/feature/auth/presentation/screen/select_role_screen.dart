import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:practice_riverpod/core/common/custom_button.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class SelectRoleScreen extends ConsumerWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.network(
                    "https://static.vecteezy.com/system/resources/thumbnails/060/199/333/small/minimalist-abstract-3d-curve-in-glowing-green-tone-on-dark-background-elegant-and-modern-visual-for-tech-presentations-ai-projects-website-headers-and-futuristic-graphic-design-templates-vector.jpg",
                    width: double.infinity,
                    height: 140.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 140.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 44.r,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Title
              CustomText(
                text: 'Welcome to App',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              ),

              SizedBox(height: 8.h),

              // Subtitle
              CustomText(
                text:
                    'Please sign in to access your existing account or create a new account to get started.',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
                height: 1.4,
              ),

              const Spacer(),

              // Role Selection Cards
              CustomButton(
                text: 'Log In',
                buttonType: ButtonType.filled,
                onTap: () {
                  context.push(AppRoute.loginScreen);
                },
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'Create Account',
                buttonType: ButtonType.outlined,
                onTap: () {
                  context.push(AppRoute.registerScreen);
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
