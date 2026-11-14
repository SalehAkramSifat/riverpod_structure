import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/extensions/build_context_extensions.dart';

extension AsyncValueUI on AsyncValue<dynamic> {
  /// Displays an error SnackBar automatically when this AsyncValue fails.
  /// Ideal to call inside ref.listen in consumer widgets.
  void showSnackBarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      context.showErrorSnackBar(error.toString());
    }
  }
}
