import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

base class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (kDebugMode) {
      log(
        '➕ Provider Added: ${context.provider.name ?? context.provider.runtimeType} | Value: $value',
        name: 'Riverpod',
      );
    }
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (kDebugMode) {
      log(
        '🔄 Provider Updated: ${context.provider.name ?? context.provider.runtimeType}\n   Previous: $previousValue\n   New: $newValue',
        name: 'Riverpod',
      );
    }
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    super.didDisposeProvider(context);
    if (kDebugMode) {
      log(
        '🗑️ Provider Disposed: ${context.provider.name ?? context.provider.runtimeType}',
        name: 'Riverpod',
      );
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (kDebugMode) {
      log(
        '❌ Provider Failed: ${context.provider.name ?? context.provider.runtimeType}\n   Error: $error',
        name: 'Riverpod',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Alias for backwards compatibility
typedef Observers = AppProviderObserver;
