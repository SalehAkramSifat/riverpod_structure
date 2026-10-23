import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/network/network_service.dart';

/// Provides network caller service (HTTP)
final networkServiceProvider = Provider<NetworkCaller>((ref) {
  return NetworkCaller();
});
