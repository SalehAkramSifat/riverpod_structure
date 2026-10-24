import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';
import 'package:riverpod_structure/routes/app_router.dart';

class AppSnackBar {
  AppSnackBar._();

  static OverlayEntry? _currentEntry;

  static void showError(
    String message, {
    BuildContext? context,
    String title = 'Error',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      message: message,
      context: context,
      title: title,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
      duration: duration,
    );
  }

  static void showSuccess(
    String message, {
    BuildContext? context,
    String title = 'Success',
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      message: message,
      context: context,
      title: title,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
      duration: duration,
    );
  }

  static void _show({
    required String message,
    BuildContext? context,
    required String title,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final targetContext = context ?? rootNavigatorKey.currentContext;
    if (targetContext == null) return;

    final overlay =
        Overlay.maybeOf(targetContext) ??
        rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    // Remove any currently active snackbar
    _currentEntry?.remove();
    _currentEntry = null;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _TopSnackBarWidget(
        title: title,
        message: message,
        backgroundColor: backgroundColor,
        icon: icon,
        duration: duration,
        onDismissed: () {
          if (_currentEntry == entry) {
            entry.remove();
            _currentEntry = null;
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _TopSnackBarWidget extends StatefulWidget {
  final String title;
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismissed;

  const _TopSnackBarWidget({
    required this.title,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<_TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
      reverseDuration: const Duration(milliseconds: 400),
    );

    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0, -1.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    _timer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (_) => widget.onDismissed(),
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(widget.icon, color: AppColors.white, size: 28.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: widget.title,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                              SizedBox(height: 2.h),
                              CustomText(
                                text: widget.message,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.white,
                                maxLines: 3,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
