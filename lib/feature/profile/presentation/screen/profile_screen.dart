import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practice_riverpod/core/common/app_snackbar.dart';
import 'package:practice_riverpod/core/common/custom_appbar.dart';
import 'package:practice_riverpod/core/common/custom_confirmation_popup.dart';
import 'package:practice_riverpod/core/common/custom_text.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/utils/app_colors.dart';
import 'package:practice_riverpod/feature/profile/controller/profile/profile_controller.dart';
import 'package:practice_riverpod/routes/app_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).getMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.userData;
    final initial = (user?.fullName.isNotEmpty ?? false)
        ? user!.fullName.trim()[0].toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppbar(title: 'My Profile', showBackIcon: true),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await ref.read(profileProvider.notifier).getMe();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // 1. Profile Avatar & User Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
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
                  child: profileState.isLoading && user == null
                      ? SizedBox(
                          height: 140.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            CircleAvatar(
                              radius: 46.r,
                              backgroundColor: AppColors.primary.withValues(
                                alpha: 0.15,
                              ),
                              child: Text(
                                initial,
                                style: GoogleFonts.inter(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),

                            SizedBox(height: 14.h),

                            // User Name
                            CustomText(
                              text: user?.fullName ?? 'User Name',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),

                            SizedBox(height: 4.h),

                            // User Email
                            CustomText(
                              text: user?.email ?? 'No email provided',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),

                            SizedBox(height: 12.h),

                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    user?.isVerified == true
                                        ? Icons.verified_rounded
                                        : Icons.work_outline_rounded,
                                    size: 14.sp,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    user?.isVerified == true
                                        ? 'Verified Member'
                                        : 'Job Seeker',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),

              SizedBox(height: 20.h),

              Row(
                children: [
                  _buildStatCard(
                    title: 'Applied',
                    count: '12',
                    icon: Icons.send_rounded,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 12.w),
                  _buildStatCard(
                    title: 'Saved',
                    count: '5',
                    icon: Icons.bookmark_rounded,
                    color: const Color(0xFFF59E0B),
                  ),
                  SizedBox(width: 12.w),
                  _buildStatCard(
                    title: 'Interviews',
                    count: '2',
                    icon: Icons.video_call_rounded,
                    color: const Color(0xFF10B981),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              CustomText(
                text: 'Account Settings',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),

              SizedBox(height: 12.h),

              _buildSectionCard([
                _buildMenuTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Personal Information',
                  subtitle: 'Update your name, bio & contact details',
                  onTap: () {
                    AppSnackBar.showSuccess('Personal info tapped');
                  },
                ),
                _buildDivider(),
                _buildMenuTile(
                  icon: Icons.description_outlined,
                  title: 'My Resume / CV',
                  subtitle: 'Upload and manage your CV files',
                  onTap: () {
                    AppSnackBar.showSuccess('Manage Resume tapped');
                  },
                ),
                _buildDivider(),
                _buildMenuTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  subtitle: 'Update your security credentials',
                  onTap: () {
                    context.push(AppRoute.forgotPasswordScreen);
                  },
                ),
                _buildDivider(),
                _buildMenuTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Manage alert preferences',
                  onTap: () {
                    AppSnackBar.showSuccess('Notification settings tapped');
                  },
                ),
              ]),

              SizedBox(height: 24.h),

              CustomText(
                text: 'Support & Legal',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),

              SizedBox(height: 12.h),

              _buildSectionCard([
                _buildMenuTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center & FAQ',
                  onTap: () {
                    AppSnackBar.showSuccess('Help Center tapped');
                  },
                ),
                _buildDivider(),
                _buildMenuTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    AppSnackBar.showSuccess('Privacy Policy tapped');
                  },
                ),
                _buildDivider(),
                _buildMenuTile(
                  icon: Icons.article_outlined,
                  title: 'Terms of Service',
                  onTap: () {
                    AppSnackBar.showSuccess('Terms of Service tapped');
                  },
                ),
              ]),

              SizedBox(height: 24.h),

              // 5. Danger Zone: Logout Button
              _buildSectionCard([
                _buildMenuTile(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  titleColor: AppColors.error,
                  iconColor: AppColors.error,
                  showArrow: false,
                  onTap: () {
                    CustomConfirmationPopup.show(
                      context: context,
                      title: 'Log Out',
                      message:
                          'Are you sure you want to log out of your account?',
                      confirmButtonText: 'Log Out',
                      cancelButtonText: 'Cancel',
                      isDestructive: true,
                      icon: Icons.logout_rounded,
                      onConfirm: () async {
                        context.pop();
                        await AuthService.logoutUser();
                      },
                    );
                  },
                ),
              ]),

              SizedBox(height: 24.h),

              // App Version
              Center(
                child: CustomText(
                  text: 'Version 1.0.0 • Practice Riverpod',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
      ),
    );
  }

  // 📊 Reusable Quick Stat Card
  Widget _buildStatCard({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.textFormFieldBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              count,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            CustomText(
              text: title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  // 🧱 Grouped Card Container
  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textFormFieldBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // 🔘 Reusable Menu Tile
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? titleColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: iconColor ?? AppColors.primary,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.textPrimary,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      CustomText(
                        text: subtitle,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: AppColors.outlineBorder,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 54.w,
      endIndent: 16.w,
      color: const Color(0xFFF1F5F9),
    );
  }
}
