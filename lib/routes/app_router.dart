import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  // Route Paths
  static const String home = '/';
  static const String movieDetail = '/movieDetail';
  static const String bookmarks = '/bookmarks';

  // Route List
  static final List<RouteBase> routes = [
    // GoRoute(
    //   path: home,
    //   name: 'home',
    //   builder: (context, state) => HomePage(key: state.pageKey),
    // ),
    // GoRoute(
    //   path: movieDetail,
    //   name: 'movieDetail',
    //   builder: (context, state) =>
    //       MovieDetailScreen(key: state.pageKey, movieId: state.extra as int),
    // ),
    // GoRoute(
    //   path: bookmarks,
    //   name: 'bookmarks',
    //   builder: (context, state) => BookmarkScreen(key: state.pageKey),
    // ),
  ];
}

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.home,
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: false,
    routes: AppRoute.routes,
  );
});

/*

1. NAVIGATION 
   // Push to new screen 
   context.push(AppRoute.bookmarks);

   // Go to screen 
   context.go(AppRoute.home);

   // Pop / Go back 
   context.pop();

2. PASSING ARGUMENTS  :
   context.push(AppRoute.movieDetail, extra: movie.id);

*/
