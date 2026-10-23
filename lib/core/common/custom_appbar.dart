import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';

enum AppBarMode {
  minimal,
  centerText,
  textOnly,
  textWithBack,
  textWithTrailing,
}

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarMode mode;
  final String? title;
  final Widget? trailingIcon;
  final Widget? leading;
  final IconData? backIcon;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? titleColor;
  final Color? backIconColor;
  final Color? backgroundColor;
  final VoidCallback? onBackPressed;
  final bool showBackIcon;
  final bool centerTitle;
  final double toolbarHeight;
  final bool showBottomDivider;
  final Color? dividerColor;

  const CustomAppbar({
    super.key,
    this.mode = AppBarMode.textWithBack,
    this.title,
    this.trailingIcon,
    this.leading,
    this.backIcon,
    this.fontSize,
    this.fontWeight,
    this.titleColor,
    this.backIconColor,
    this.backgroundColor,
    this.onBackPressed,
    this.showBackIcon = true,
    this.centerTitle = true,
    this.toolbarHeight = 56.0,
    this.showBottomDivider = false,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.backgroundDark : AppColors.white;
    final defaultTextAndIconColor = isDark ? AppColors.white : AppColors.black;

    final effectiveBgColor = backgroundColor ?? defaultBg;
    final effectiveTitleColor = titleColor ?? defaultTextAndIconColor;
    final effectiveBackIconColor = backIconColor ?? defaultTextAndIconColor;
    final hasTitle = title != null && title!.trim().isNotEmpty;

    return Container(
      color: effectiveBgColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: toolbarHeight.h,
          decoration: showBottomDivider
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          dividerColor ??
                          (isDark ? Colors.white12 : Colors.black12),
                      width: 1.h,
                    ),
                  ),
                )
              : null,
          child: _buildContent(
            context,
            hasTitle: hasTitle,
            titleColor: effectiveTitleColor,
            backIconColor: effectiveBackIconColor,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required bool hasTitle,
    required Color titleColor,
    required Color backIconColor,
  }) {
    switch (mode) {
      case AppBarMode.minimal:
        return const SizedBox.expand();

      case AppBarMode.centerText:
        return Center(
          child: _buildTitle(
            hasTitle: hasTitle,
            titleColor: titleColor,
            textAlign: TextAlign.center,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        );

      case AppBarMode.textOnly:
        return Align(
          alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
          child: _buildTitle(
            hasTitle: hasTitle,
            titleColor: titleColor,
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
        );

      case AppBarMode.textWithBack:
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildBackButton(context, backIconColor),
            _buildTitle(
              hasTitle: hasTitle,
              titleColor: titleColor,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              padding: EdgeInsets.symmetric(
                horizontal: showBackIcon ? 56.w : 16.w,
              ),
            ),
          ],
        );

      case AppBarMode.textWithTrailing:
        return Stack(
          alignment: Alignment.center,
          children: [
            _buildBackButton(context, backIconColor),
            _buildTitle(
              hasTitle: hasTitle,
              titleColor: titleColor,
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
              padding: EdgeInsets.symmetric(
                horizontal: (showBackIcon || trailingIcon != null)
                    ? 56.w
                    : 16.w,
              ),
            ),
            if (trailingIcon != null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: trailingIcon!,
                ),
              ),
          ],
        );
    }
  }

  Widget _buildBackButton(BuildContext context, Color iconColor) {
    if (!showBackIcon) return const SizedBox.shrink();

    if (leading != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: leading!,
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed:
            onBackPressed ??
            () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
        icon: Icon(
          backIcon ?? Icons.arrow_back_sharp,
          size: 24.sp,
          color: iconColor,
        ),
        splashRadius: 22.r,
        tooltip: 'Back',
      ),
    );
  }

  Widget _buildTitle({
    required bool hasTitle,
    required Color titleColor,
    required TextAlign textAlign,
    EdgeInsetsGeometry? padding,
  }) {
    if (!hasTitle) return const SizedBox.shrink();

    final textWidget = CustomText(
      text: title!,
      fontSize: fontSize ?? 16.sp,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: titleColor,
      textAlign: textAlign,
      maxLines: 1,
      textOverflow: TextOverflow.ellipsis,
    );

    if (padding != null) {
      return Padding(padding: padding, child: textWidget);
    }

    return textWidget;
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight.h);
}

// =============================================================================
// 🚀 CustomAppbar Usage Examples 
// =============================================================================

/// Mode 1: Minimal  
  
/// CustomAppbar(
///   mode: AppBarMode.minimal,
/// )
 

/// Mode 2: Center Text Only 
 
/// CustomAppbar(
///   mode: AppBarMode.centerText,
///   title: "Dashboard",
///   fontSize: 18.sp,
/// )
 

/// Mode 3: Text with Back Button 
 
/// CustomAppbar(
///   mode: AppBarMode.textWithBack,
///   title: "Movie Details",
///   onBackPressed: () => Navigator.pop(context),
/// )
 

/// Mode 4: Text + Back Button + Trailing Icon 
 
/// CustomAppbar(
///   mode: AppBarMode.textWithTrailing,
///   title: "Search Results",
///   trailingIcon: IconButton(
///     icon: const Icon(Icons.tune),
///     onPressed: () {},
///   ),
/// )
 

/// Mode 5: Text Only 
 
/// CustomAppbar(
///   mode: AppBarMode.textOnly,
///   title: "Explore Movies",
///   centerTitle: false,
/// )
 
