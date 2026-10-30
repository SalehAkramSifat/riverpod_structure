import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/common/network_image_handler.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String companyName;
  final String location;
  final String salary;
  final String jobType;
  final String category;
  final String? logoUrl;
  final String postedTime;
  final bool isBookmarked;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkTap;

  const JobCard({
    super.key,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.category,
    this.logoUrl,
    required this.postedTime,
    this.isBookmarked = false,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.textFormFieldBorder,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Logo, Title, Company and Bookmark
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Logo with NetworkImageHandler
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        color: const Color(0xFFF1F5F9),
                        child: NetworkImageHandler(
                          imageUrl: logoUrl,
                          width: 48.w,
                          height: 48.h,
                          fit: BoxFit.cover,
                          errorWidget: Container(
                            color: const Color(0xFFF1F5F9),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.business_rounded,
                              size: 26.r,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Title & Company using CustomText
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: title,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 3.h),
                          CustomText(
                            text: companyName,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            maxLines: 1,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Bookmark Button
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isBookmarked
                            ? AppColors.primary
                            : AppColors.outlineBorder,
                        size: 24.r,
                      ),
                      onPressed: onBookmarkTap,
                    ),
                  ],
                ),

                SizedBox(height: 14.h),

                // Location and Posted Time using CustomText
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: location,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14.sp,
                      color: AppColors.textTertiary,
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: postedTime,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),

                SizedBox(height: 14.h),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                SizedBox(height: 12.h),

                // Bottom Row: Badges & Salary using CustomText
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Job Type Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            text: jobType,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),

                        // Category Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: CustomText(
                            text: category,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    // Salary using CustomText
                    CustomText(
                      text: salary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
