import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? subtitle;
  final String? avatarLetter;
  final String? avatarUrl;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.subtitle = 'Find your dream opportunity',
    this.avatarLetter,
    this.avatarUrl,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final letter = avatarLetter ??
        (userName.trim().isNotEmpty ? userName.trim()[0].toUpperCase() : 'U');

    return Row(
      children: [
        // User Avatar
        GestureDetector(
          onTap: onProfileTap,
          child: CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    letter,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
        ),
        SizedBox(width: 12.w),

        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Hello, $userName 👋',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2.h),
                CustomText(
                  text: subtitle!,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ),

        // Notification Button
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.textFormFieldBorder,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            color: AppColors.textPrimary,
            onPressed: onNotificationTap,
          ),
        ),
        SizedBox(width: 8.w),

        // Profile Button
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.textFormFieldBorder,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            color: AppColors.textPrimary,
            onPressed: onProfileTap,
          ),
        ),
      ],
    );
  }
}

