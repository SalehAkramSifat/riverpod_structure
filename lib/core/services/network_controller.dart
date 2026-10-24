import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/logging/logger.dart';

/// Immutable state representing network connectivity.
class NetworkState {
  final bool isConnected;
  final bool isChecking;

  const NetworkState({
    this.isConnected = true,
    this.isChecking = false,
  });

  NetworkState copyWith({
    bool? isConnected,
    bool? isChecking,
  }) {
    return NetworkState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkState &&
          runtimeType == other.runtimeType &&
          isConnected == other.isConnected &&
          isChecking == other.isChecking;

  @override
  int get hashCode => isConnected.hashCode ^ isChecking.hashCode;
}

/// Global controller to monitor real-time network connectivity.
///
/// Features:
/// - Real-time stream listening via [Connectivity]
/// - Verification of real internet access via DNS lookup (avoids "Connected without Internet" false positives)
/// - Exposes reactive [NetworkState] and synchronous [isConnectedNow] helper
class NetworkController extends Notifier<NetworkState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Fast synchronous flag for non-widget callers (e.g., NetworkCaller)
  static bool isConnectedNow = true;

  @override
  NetworkState build() {
    _initConnectivity();
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return const NetworkState(isConnected: true, isChecking: false);
  }

  Future<void> _initConnectivity() async {
    await checkConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChanged);
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) async {
    AppLogger.info('📡 Connectivity change detected: $results');

    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      _updateStatus(false);
      return;
    }

    final hasInternet = await _hasRealInternet();
    _updateStatus(hasInternet);
  }

  /// Explicitly check connectivity (useful for "Try Again" callbacks).
  Future<bool> checkConnection() async {
    state = state.copyWith(isChecking: true);
    try {
      final results = await _connectivity.checkConnectivity();

      if (results.contains(ConnectivityResult.none) || results.isEmpty) {
        _updateStatus(false);
        return false;
      }

      final hasInternet = await _hasRealInternet();
      _updateStatus(hasInternet);
      return hasInternet;
    } catch (e) {
      AppLogger.error('❌ Error checking network connectivity: $e');
      _updateStatus(false);
      return false;
    } finally {
      state = state.copyWith(isChecking: false);
    }
  }

  void _updateStatus(bool connected) {
    isConnectedNow = connected;
    state = state.copyWith(isConnected: connected);
  }

  /// Pings google.com via DNS lookup to verify real internet reachability.
  Future<bool> _hasRealInternet() async {
    if (kIsWeb) {
      return true;
    }

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 4));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}

/// Global provider for [NetworkController]
final networkControllerProvider =
    NotifierProvider<NetworkController, NetworkState>(NetworkController.new);

/// Convenience provider for listening only to connectivity boolean
final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(networkControllerProvider).isConnected;
});
