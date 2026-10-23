import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';

enum ButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final ButtonType buttonType;
  final Widget? prefixIcon;
  final Widget? nextIcon;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? radius;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? image;
  final double? width;
  final double? height;
  final bool isFullWidth;
  final bool showPrefixIcon;
  final bool showNextIcon;
  final bool isLoading;
  final bool isEnabled;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.buttonType = ButtonType.filled,
    this.prefixIcon,
    this.nextIcon,
    this.child,
    this.padding,
    this.borderRadius,
    this.radius,
    this.color,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1.2,
    this.disabledColor,
    this.disabledTextColor,
    this.fontSize,
    this.fontWeight,
    this.image,
    this.width,
    this.height,
    this.isFullWidth = true,
    this.showPrefixIcon = true,
    this.showNextIcon = true,
    this.isLoading = false,
    this.isEnabled = true,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final bool canTap = isEnabled && !isLoading && onTap != null;
    final BorderRadius effectiveRadius =
        borderRadius ?? BorderRadius.circular((radius ?? 8.0).r);

    final bool isOutlined = buttonType == ButtonType.outlined;
    final bool isText = buttonType == ButtonType.text;

    // Background color
    final Color effectiveBgColor;
    if (isOutlined || isText) {
      effectiveBgColor = color ?? Colors.transparent;
    } else {
      effectiveBgColor = canTap
          ? (color ?? AppColors.primary)
          : (disabledColor ?? Colors.grey.shade400);
    }

    // Text & spinner color
    final Color effectiveTextColor;
    if (canTap) {
      if (textColor != null) {
        effectiveTextColor = textColor!;
      } else if (isOutlined || isText) {
        effectiveTextColor = color ?? borderColor ?? AppColors.primary;
      } else {
        effectiveTextColor = Colors.white;
      }
    } else {
      effectiveTextColor =
          disabledTextColor ??
          (isOutlined ? Colors.grey.shade400 : Colors.white70);
    }

    // Border
    final BoxBorder? effectiveBorder;
    if (border != null) {
      effectiveBorder = border;
    } else if (isOutlined) {
      final effectiveBorderColor = canTap
          ? (borderColor ?? color ?? AppColors.primary)
          : (disabledColor ?? Colors.grey.shade400);
      effectiveBorder = Border.all(
        color: effectiveBorderColor,
        width: borderWidth,
      );
    } else {
      effectiveBorder = null;
    }

    // Splash / Highlight colors
    final Color splashColor;
    final Color highlightColor;
    if (isOutlined || isText) {
      final Color tintColor = borderColor ?? color ?? AppColors.primary;
      splashColor = tintColor.withValues(alpha: 0.12);
      highlightColor = tintColor.withValues(alpha: 0.06);
    } else {
      splashColor = Colors.white.withValues(alpha: 0.2);
      highlightColor = Colors.white.withValues(alpha: 0.1);
    }

    Widget effectivePrefix;
    if (image != null && image!.isNotEmpty) {
      effectivePrefix = Image.asset(
        image!,
        height: 20.r,
        width: 20.r,
        fit: BoxFit.contain,
      );
    } else {
      effectivePrefix = prefixIcon ?? const SizedBox.shrink();
    }

    Widget buttonContent = Material(
      color: effectiveBgColor,
      borderRadius: effectiveRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        splashColor: canTap ? splashColor : Colors.transparent,
        highlightColor: canTap ? highlightColor : Colors.transparent,
        borderRadius: effectiveRadius,
        onTap: canTap ? onTap : null,
        child: Container(
          width: isFullWidth ? (width ?? double.infinity) : width,
          height: height,
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: effectiveRadius,
            border: effectiveBorder,
          ),
          child: Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  height: 20.r,
                  width: 20.r,
                  child: CircularProgressIndicator(
                    color: effectiveTextColor,
                    strokeWidth: 2.5,
                  ),
                )
              else ...[
                if ((prefixIcon != null || image != null) &&
                    showPrefixIcon) ...[
                  SizedBox(
                    height: 20.r,
                    width: 20.r,
                    child: Center(child: effectivePrefix),
                  ),
                  SizedBox(width: 8.w),
                ],

                if (child != null)
                  child!
                else
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: fontSize ?? 16.sp,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      color: effectiveTextColor,
                    ),
                  ),

                if (nextIcon != null && showNextIcon) ...[
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 20.r,
                    width: 20.r,
                    child: Center(child: nextIcon),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    if (boxShadow != null && canTap && !isOutlined && !isText) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          boxShadow: boxShadow,
        ),
        child: buttonContent,
      );
    }

    return buttonContent;
  }
}
