import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_structure/core/utils/app_strings.dart';
import 'package:riverpod_structure/core/extensions/build_context_extensions.dart';
import 'package:riverpod_structure/core/theme/app_theme_provider.dart';

import 'drawer_item.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeState = ref.watch(appThemeProvider);
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.sp),
          bottomRight: Radius.circular(16.sp),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/movies/drawer.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              AppStrings.appName,
              style: context.textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 20),
            child: Text(
              'Colour Scheme',
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          DrawerItem(
            title: 'Dark Mode',
            asset: 'assets/images/icons/night.svg',
            onTap: () => _onTap('dark', ref),
            isSelected: currentThemeState == ThemeMode.dark,
          ),
          DrawerItem(
            title: 'Light Mode',
            asset: 'assets/images/icons/sun.svg',
            onTap: () => _onTap('light', ref),
            isSelected: currentThemeState == ThemeMode.light,
          ),
          DrawerItem(
            title: 'Default System',
            onTap: () => _onTap('default', ref),
            asset: 'assets/images/icons/default.svg',
            isSelected: currentThemeState == ThemeMode.system,
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _onTap(String which, WidgetRef ref) {
    switch (which) {
      case 'dark':
        ref.read(appThemeProvider.notifier).setDarkTheme();
        break;
      case 'light':
        ref.read(appThemeProvider.notifier).setLightTheme();
        break;
      case 'default':
        ref.read(appThemeProvider.notifier).setSystemTheme();
        break;
    }
  }

}
