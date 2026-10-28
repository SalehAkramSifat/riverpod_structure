import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/logging/logger.dart';

base class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (kDebugMode) {
      AppLogger.trace(
        'Provider Added: ${context.provider.name ?? context.provider.runtimeType}',
        tag: 'Riverpod',
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
      AppLogger.trace(
        'Provider Updated: ${context.provider.name ?? context.provider.runtimeType}',
        tag: 'Riverpod',
      );
    }
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    super.didDisposeProvider(context);
    if (kDebugMode) {
      AppLogger.trace(
        'Provider Disposed: ${context.provider.name ?? context.provider.runtimeType}',
        tag: 'Riverpod',
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
      AppLogger.error(
        'Provider Failed: ${context.provider.name ?? context.provider.runtimeType}',
        tag: 'Riverpod',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Alias for backwards compatibility
typedef Observers = AppProviderObserver;
