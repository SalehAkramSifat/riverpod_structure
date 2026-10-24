import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/common/no_internet_screen.dart';
import 'package:riverpod_structure/core/services/network_controller.dart';
import 'package:riverpod_structure/core/theme/app_theme.dart';
import 'package:riverpod_structure/core/theme/app_theme_provider.dart';
import 'package:riverpod_structure/core/utils/app_strings.dart';
import 'routes/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(appThemeProvider);
    final networkState = ref.watch(networkControllerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppStrings.appName,
          darkTheme: AppTheme.darkTheme,
          theme: AppTheme.lightTheme,
          themeMode: themeMode,
          routerConfig: goRouter,
          debugShowCheckedModeBanner: false,
          builder: (context, routerChild) {
            return Stack(
              children: [
                ?routerChild,
                if (!networkState.isConnected)
                  Positioned.fill(
                    child: NoInternetScreen(
                      isRetrying: networkState.isChecking,
                      onRetry: () => ref
                          .read(networkControllerProvider.notifier)
                          .checkConnection(),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
