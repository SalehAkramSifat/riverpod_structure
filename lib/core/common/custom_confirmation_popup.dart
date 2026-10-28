import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_structure/core/common/custom_text.dart';
import 'package:riverpod_structure/core/utils/app_colors.dart';

class CustomConfirmationPopup extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final IconData? icon;

  const CustomConfirmationPopup({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.onCancel,
    this.isDestructive = false,
    this.icon,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmButtonText = 'Confirm',
    String cancelButtonText = 'Cancel',
    VoidCallback? onCancel,
    bool isDestructive = false,
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return CustomConfirmationPopup(
          title: title,
          message: message,
          onConfirm: onConfirm,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          onCancel: onCancel,
          isDestructive: isDestructive,
          icon: icon,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryActionColor = isDestructive
        ? Colors.redAccent
        : (isDark ? AppColors.white : AppColors.black);
    final IconData displayIcon =
        icon ??
        (isDestructive
            ? Icons.warning_amber_rounded
            : Icons.info_outline_rounded);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryActionColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(displayIcon, size: 40, color: primaryActionColor),
            ),
            const SizedBox(height: 20),

            CustomText(
              text: title,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : Colors.black87,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            CustomText(
              text: message,
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (onCancel != null) {
                        onCancel!();
                      }
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                    child: CustomText(
                      text: cancelButtonText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryActionColor,
                      foregroundColor: isDestructive ? Colors.white : (isDark ? AppColors.black : Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: CustomText(
                      text: confirmButtonText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.white : (isDark ? AppColors.black : Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
