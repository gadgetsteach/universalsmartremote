import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/home/screens/saved_remotes_screen.dart';
import '../../presentation/categories/screens/category_screen.dart';
import '../../presentation/brands/screens/brand_list_screen.dart';
import '../../presentation/brands/screens/remote_test_screen.dart';
import '../../presentation/remote/screens/tv_remote_screen.dart';
import '../../presentation/remote/screens/ac_remote_screen.dart';
import '../../presentation/settings/screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SavedRemotesScreen(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const CategoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/brands/:category',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return BrandListScreen(category: category);
        },
      ),
      GoRoute(
        path: '/test/:category/:brand',
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          final brand = state.pathParameters['brand']!;
          return RemoteTestScreen(category: category, brand: brand);
        },
      ),
      GoRoute(
        path: '/remote/tv/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final savedIdStr = state.uri.queryParameters['savedId'];
          final savedId = savedIdStr != null ? int.tryParse(savedIdStr) : null;
          return TvRemoteScreen(deviceId: id, savedRemoteId: savedId);
        },
      ),
      GoRoute(
        path: '/remote/ac/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final savedIdStr = state.uri.queryParameters['savedId'];
          final savedId = savedIdStr != null ? int.tryParse(savedIdStr) : null;
          return AcRemoteScreen(deviceId: id, savedRemoteId: savedId);
        },
      ),
    ],
  );
});
