import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/logging/logger.dart';

class NetworkState {
  final bool isConnected;
  final bool isChecking;

  const NetworkState({this.isConnected = true, this.isChecking = false});

  NetworkState copyWith({bool? isConnected, bool? isChecking}) {
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

class NetworkController extends Notifier<NetworkState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  static bool isConnectedNow = true;

  bool _isDisposed = false;

  @override
  NetworkState build() {
    ref.onDispose(() {
      _isDisposed = true;
      _subscription?.cancel();
    });
    Future.microtask(() => _initConnectivity());
    return const NetworkState(isConnected: true, isChecking: false);
  }

  Future<void> _initConnectivity() async {
    await checkConnection();
    if (!_isDisposed) {
      _subscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChanged,
      );
    }
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

  Future<bool> checkConnection() async {
    if (_isDisposed) return isConnectedNow;
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
      if (!_isDisposed) {
        state = state.copyWith(isChecking: false);
      }
    }
  }

  void _updateStatus(bool connected) {
    isConnectedNow = connected;
    if (!_isDisposed) {
      state = state.copyWith(isConnected: connected);
    }
  }

  Future<bool> _hasRealInternet() async {
    if (kIsWeb) {
      return true;
    }

    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 4));
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

final networkControllerProvider =
    NotifierProvider<NetworkController, NetworkState>(NetworkController.new);

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(networkControllerProvider).isConnected;
});
