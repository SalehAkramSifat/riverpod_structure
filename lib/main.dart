import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/services/auth_service.dart';
import 'package:riverpod_structure/core/services/network_service.dart';
import 'package:riverpod_structure/core/utils/app_provider_observer.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthService.init();

  NetworkCaller.onUnauthorized = () => AuthService.logoutUser();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(observers: [AppProviderObserver()], child: const MyApp()),
  );
}
