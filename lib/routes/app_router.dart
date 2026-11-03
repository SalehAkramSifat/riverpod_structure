import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_structure/feature/presentation/screen/welcome_screen.dart';

class AppRoute {
  // Route Paths
  static const String splash = '/';
  static const String welcome = 'welcome';

  // Route List
  static final List<RouteBase> routes = [
    GoRoute(
      path: welcome,
      name: 'welcome',
      builder: (context, state) => WelcomeScreen(key: state.pageKey),
    ),
  ];
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.welcome,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: AppRoute.routes,
  );
});

/*
NAVIGATION USAGE:
1. Navigate to screen:
   context.go(AppRoute.welcome);

2. Push screen:
   context.push('/someRoute');

3. Pop / Go Back:
   context.pop();
*/
