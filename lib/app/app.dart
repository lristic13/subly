import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/providers/settings_providers.dart';
import '../shared/providers/shared_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Splash background color matching native splash
const _splashBackgroundColor = Color(0xFF0F0F23);

/// Main application widget
class SublyApp extends ConsumerWidget {
  const SublyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Show loading screen while settings load to prevent theme flash
    if (settings.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ColoredBox(color: _splashBackgroundColor),
      );
    }

    final router = ref.watch(routerProvider);
    final themeMode = settings.valueOrNull?.themeMode ?? ThemeMode.system;

    // Fetch and cache exchange rates at app startup
    ref.watch(exchangeRatesProvider);

    return MaterialApp.router(
      title: 'Subly.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
