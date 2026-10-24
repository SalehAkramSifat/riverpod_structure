import 'package:flutter/material.dart';
import 'package:riverpod_structure/core/common/app_snackbar.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  Size get screenSize => MediaQuery.sizeOf(this);
  Orientation get orientation => MediaQuery.orientationOf(this);

  double get sizeWidth => width;
  double get sizeHeight => height;

  EdgeInsets get padding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  bool get isKeyboardOpen => MediaQuery.viewInsetsOf(this).bottom > 0;

  void unfocus() => FocusScope.of(this).unfocus();

  void showSnackBar(String message, {bool isError = false, String? title}) {
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

  void showErrorSnackBar(String message, {String title = 'Error'}) =>
      AppSnackBar.showError(message, context: this, title: title);

  void showSuccessSnackBar(String message, {String title = 'Success'}) =>
      AppSnackBar.showSuccess(message, context: this, title: title);
}
