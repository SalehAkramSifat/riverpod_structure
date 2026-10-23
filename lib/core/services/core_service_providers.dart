import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/network/dio_network_service.dart';
import 'package:riverpod_structure/core/services/network/network_service.dart';
import 'package:riverpod_structure/core/services/storage/local_db.dart';
import 'package:riverpod_structure/core/services/storage/local_db_impl.dart';
import 'package:riverpod_structure/core/services/storage/shared_pref.dart';
import 'package:riverpod_structure/core/services/storage/shared_pref_impl.dart';

/// Provides network service (HTTP via Dio)
final networkServiceProvider = Provider<NetworkService>((ref) {
  return DioNetworkService();
});

/// Provides local key-value storage (SharedPreferences)
final sharedPrefProvider = Provider<SharedPref>((ref) {
  return SharedPrefImplementation();
});

/// Provides local database
final localDbProvider = Provider<LocalDb>((ref) {
  return InitDbImpl();
});
