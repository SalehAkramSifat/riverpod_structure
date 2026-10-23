import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/network/network_service.dart';
import 'package:riverpod_structure/core/services/storage/shared_pref.dart';

/// Provides network caller service (HTTP)
final networkServiceProvider = Provider<NetworkCaller>((ref) {
  return NetworkCaller();
});

/// Provides local key-value storage (SharedPreferences)
final sharedPrefProvider = Provider<SharedPref>((ref) {
  return SharedPref();
});
