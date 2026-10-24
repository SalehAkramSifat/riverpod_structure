import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/common/custom_button.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';

enum EmptyStateType { general, search, notification, favorite, error }

class CustomEmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? customTitle;
  final String? customMessage;
  final String? searchQuery;
  final VoidCallback? onActionTap;
  final String? actionLabel;
  final bool isActionLoading;
  final IconData? icon;
  final Widget? customWidget;
  final Color? iconColor;
  final bool isCompact;
  final bool isScrollable;

  const CustomEmptyState({
    super.key,
    this.type = EmptyStateType.general,
    this.customTitle,
    this.customMessage,
    this.searchQuery,
    this.onActionTap,
    this.actionLabel,
    this.isActionLoading = false,
    this.icon,
    this.customWidget,
    this.iconColor,
    this.isCompact = false,
    this.isScrollable = true,
  });

  factory CustomEmptyState.search({
    Key? key,
    String? searchQuery,
    VoidCallback? onClear,
    String actionLabel = 'Clear Search',
    bool isCompact = false,
  }) {
    return CustomEmptyState(
      key: key,
      type: EmptyStateType.search,
      searchQuery: searchQuery,
      onActionTap: onClear,
      actionLabel: actionLabel,
      isCompact: isCompact,
    );
  }

  factory CustomEmptyState.notification({
    Key? key,
    VoidCallback? onRefresh,
    String actionLabel = 'Refresh',
    bool isCompact = false,
  }) {
    return CustomEmptyState(
      key: key,
      type: EmptyStateType.notification,
      onActionTap: onRefresh,
      actionLabel: actionLabel,
      isCompact: isCompact,
    );
  }

  factory CustomEmptyState.favorite({
    Key? key,
    VoidCallback? onExplore,
    String actionLabel = 'Explore Now',
    bool isCompact = false,
  }) {
    return CustomEmptyState(
      key: key,
      type: EmptyStateType.favorite,
      onActionTap: onExplore,
      actionLabel: actionLabel,
      isCompact: isCompact,
    );
  }

  factory CustomEmptyState.error({
    Key? key,
    String? errorMessage,
    VoidCallback? onRetry,
    String actionLabel = 'Try Again',
    bool isCompact = false,
    bool isLoading = false,
  }) {
    return CustomEmptyState(
      key: key,
      type: EmptyStateType.error,
      customMessage: errorMessage,
      onActionTap: onRetry,
      actionLabel: actionLabel,
      isActionLoading: isLoading,
      isCompact: isCompact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = _getEmptyStateConfig();

    final effectiveIcon = icon ?? config.icon;
    final effectiveIconColor =
        iconColor ?? (isDark ? AppColors.chipTextDark : AppColors.primary);

    final String effectiveTitle =
        customTitle ??
        ((searchQuery != null && searchQuery!.trim().isNotEmpty)
            ? 'No Results Found'
            : config.title);

    final String effectiveMessage =
        customMessage ??
        ((searchQuery != null && searchQuery!.trim().isNotEmpty)
            ? "We couldn't find any matches for \"${searchQuery!.trim()}\". Try checking for typos or searching with different keywords."
            : config.message);

    final Widget content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 16.w : 32.w,
        vertical: isCompact ? 16.h : 36.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Visual Icon or Custom Widget (e.g. Lottie/Svg)
          if (customWidget != null)
            customWidget!
          else
            Container(
              width: isCompact ? 64.w : 96.w,
              height: isCompact ? 64.w : 96.w,
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                effectiveIcon,
                size: isCompact ? 32.sp : 46.sp,
                color: effectiveIconColor,
              ),
            ),

          SizedBox(height: isCompact ? 12.h : 18.h),

          // Title
          CustomText(
            text: effectiveTitle,
            fontSize: isCompact ? 16.sp : 18.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.white : AppColors.primary,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 6.h),

          // Subtitle / Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: CustomText(
              text: effectiveMessage,
              fontSize: isCompact ? 12.sp : 13.sp,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.secondaryLight : Colors.grey.shade600,
              textAlign: TextAlign.center,
              maxLines: 4,
              height: 1.4,
            ),
          ),

          // Action Button
          if (onActionTap != null) ...[
            SizedBox(height: isCompact ? 16.h : 24.h),
            CustomButton(
              text: actionLabel ?? config.actionLabel,
              onTap: onActionTap,
              isLoading: isActionLoading,
              isFullWidth: false,
              height: isCompact ? 38.h : 44.h,
              fontSize: isCompact ? 12.sp : 14.sp,
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 20.w : 28.w,
              ),
              radius: 10.r,
            ),
          ],
        ],
      ),
    );

    if (isScrollable) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: content,
        ),
      );
    }

    return Center(child: content);
  }

  EmptyStateConfig _getEmptyStateConfig() {
    switch (type) {
      case EmptyStateType.search:
        return EmptyStateConfig(
          icon: Icons.search_off_rounded,
          title: 'No Results Found',
          message:
              'Try checking for typos or searching with different keywords.',
          actionLabel: 'Clear Search',
        );
      case EmptyStateType.notification:
        return EmptyStateConfig(
          icon: Icons.notifications_off_outlined,
          title: 'No Notifications',
          message: "You're all caught up! Check back later for updates.",
          actionLabel: 'Refresh',
        );
      case EmptyStateType.favorite:
        return EmptyStateConfig(
          icon: Icons.bookmark_border_rounded,
          title: 'No Bookmarks Yet',
          message: 'Items you save or mark as favorite will appear here.',
          actionLabel: 'Explore',
        );
      case EmptyStateType.error:
        return EmptyStateConfig(
          icon: Icons.error_outline_rounded,
          title: 'Something Went Wrong',
          message:
              'Unable to load data. Please check your connection and try again.',
          actionLabel: 'Try Again',
        );
      case EmptyStateType.general:
        return EmptyStateConfig(
          icon: Icons.inbox_outlined,
          title: 'Nothing Here',
          message: 'There is no data to display at the moment.',
          actionLabel: 'Go Back',
        );
    }
  }
}

class EmptyStateConfig {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;

  EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
  });
}

/// Backward compatibility alias
typedef CustomEmptyMessage = CustomEmptyState;
