import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final bool showBackIcon;
  final VoidCallback? onBackTap;
  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double elevation;
  final double toolbarHeight;

  const CustomAppbar({
    super.key,
    this.title = '',
    this.centerTitle = true,
    this.showBackIcon = true,
    this.onBackTap,
    this.leading,
    this.trailing,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.fontSize,
    this.fontWeight,
    this.elevation = 0,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = titleColor ?? Colors.white;

    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.black,
      elevation: elevation,
      toolbarHeight: toolbarHeight,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      titleSpacing: showBackIcon ? 0 : 16.w,
      leading:
          leading ??
          (showBackIcon
              ? IconButton(
                  onPressed: onBackTap ?? () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: effectiveTitleColor,
                    size: 24.r,
                  ),
                  splashRadius: 22,
                  tooltip: 'Back',
                )
              : null),
      title: title.isNotEmpty
          ? CustomText(
              text: title,
              color: effectiveTitleColor,
              fontSize: fontSize ?? 18.sp,
              fontWeight: fontWeight ?? FontWeight.w600,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            )
          : null,
      actions:
          actions ??
          (trailing != null
              ? [
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Center(child: trailing!),
                  ),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
