import 'package:flutter/material.dart';
import 'package:riverpod_structure/core/widgets/app_snackbar.dart';

extension BuildContextExtension on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Screen dimensions (Flutter 3.7+ efficient sizeOf)
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  Size get screenSize => MediaQuery.sizeOf(this);
  Orientation get orientation => MediaQuery.orientationOf(this);

  double get sizeWidth => width;
  double get sizeHeight => height;

  // Responsive breakpoints
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  // Insets and Keyboard
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();

  // Navigation shortcuts
  void pop<T extends Object?>([T? result]) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop(result);
    }
  }

  bool get canPop => Navigator.of(this).canPop();

  // SnackBar helpers with mounted safety
  void showSnackBar(String message, {bool isError = false, String? title}) {
    if (!mounted) return;
    if (isError) {
      AppSnackBar.showError(message, context: this, title: title ?? 'Error');
    } else {
      AppSnackBar.showSuccess(
        message,
        context: this,
        title: title ?? 'Success',
      );
    }
  }

  void showErrorSnackBar(String message, {String title = 'Error'}) {
    if (!mounted) return;
    AppSnackBar.showError(message, context: this, title: title);
  }

  void showSuccessSnackBar(String message, {String title = 'Success'}) {
    if (!mounted) return;
    AppSnackBar.showSuccess(message, context: this, title: title);
  }
}
