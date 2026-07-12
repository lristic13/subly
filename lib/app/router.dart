import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/catalog/domain/models/catalog_item.dart';
import '../features/catalog/presentation/screens/catalog_search_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/import/presentation/screens/import_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/onboarding/providers/onboarding_providers.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/stats/presentation/screens/stats_screen.dart';
import '../features/subscriptions/presentation/screens/add_edit_subscription_screen.dart';
import '../features/subscriptions/presentation/screens/subscription_detail_screen.dart';
import '../features/subscriptions/presentation/screens/subscriptions_list_screen.dart';
import 'shell/main_shell.dart';

part 'router.g.dart';

/// Route paths
abstract class AppRoutes {
  static const dashboard = '/';
  static const subscriptions = '/subscriptions';
  static const subscriptionAdd = '/subscriptions/add';
  static const subscriptionDetail = '/subscriptions/:id';
  static const subscriptionEdit = '/subscriptions/:id/edit';
  static const stats = '/stats';
  static const settings = '/settings';
  static const import = '/import';
  static const onboarding = '/onboarding';
}

/// Navigation shell branch keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Listenable that notifies when onboarding status changes
class _OnboardingStatusNotifier extends ChangeNotifier {
  _OnboardingStatusNotifier(this._ref) {
    _ref.listen(onboardingStatusProvider, (previous, next) => notifyListeners());
  }
  final Ref _ref;
}

@riverpod
GoRouter router(Ref ref) {
  // Use refreshListenable instead of watching directly to avoid router recreation
  final refreshNotifier = _OnboardingStatusNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.dashboard,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final onboardingStatus = ref.read(onboardingStatusProvider);

      // Wait for onboarding status to load
      if (onboardingStatus.isLoading) return null;

      final isOnboardingCompleted = onboardingStatus.valueOrNull ?? false;
      final isOnboardingRoute = state.matchedLocation == AppRoutes.onboarding;

      // If onboarding not completed and not on onboarding page, redirect to onboarding
      if (!isOnboardingCompleted && !isOnboardingRoute) {
        return AppRoutes.onboarding;
      }

      // If onboarding completed and on onboarding page, redirect to dashboard
      if (isOnboardingCompleted && isOnboardingRoute) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      // Onboarding route (outside shell)
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          // Dashboard tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Subscriptions tab
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.subscriptions,
                builder: (context, state) => const SubscriptionsListScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      return const CatalogSearchScreen();
                    },
                    routes: [
                      GoRoute(
                        path: 'custom',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          return const AddEditSubscriptionScreen();
                        },
                      ),
                      GoRoute(
                        path: 'from-catalog',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final extra = state.extra as Map<String, dynamic>?;
                          final catalogItem = extra?['catalogItem'] as CatalogItem?;
                          final currency = extra?['currency'] as String? ?? 'EUR';
                          return AddEditSubscriptionScreen(
                            catalogItem: catalogItem,
                            initialCurrency: currency,
                          );
                        },
                      ),
                    ],
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return SubscriptionDetailScreen(subscriptionId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return AddEditSubscriptionScreen(subscriptionId: id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Insights tab
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.stats,
                builder: (context, state) => const StatsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Settings is a pushed route (opened from the Home avatar)
      GoRoute(
        path: AppRoutes.settings,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.import,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ImportScreen(),
      ),
    ],
  );
}
