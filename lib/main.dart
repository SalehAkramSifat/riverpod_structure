import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/network/network.dart';
import 'package:riverpod_structure/core/storage/secure_storage_service.dart';
import 'package:riverpod_structure/core/utils/app_provider_observer.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SecureStorageService.init();

  AuthInterceptor.onUnauthorized = () {
    SecureStorageService().clearAuthData();
  };

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(observers: [AppProviderObserver()], child: const MyApp()),
  );
}
