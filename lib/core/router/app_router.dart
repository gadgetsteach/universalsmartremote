import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/home/screens/home_screen.dart';
import '../../presentation/brands/screens/brand_list_screen.dart';
import '../../presentation/brands/screens/remote_test_screen.dart';
import '../../presentation/remote/screens/tv_remote_screen.dart';
import '../../presentation/remote/screens/ac_remote_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
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
          return TvRemoteScreen(deviceId: id);
        },
      ),
      GoRoute(
        path: '/remote/ac/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AcRemoteScreen(deviceId: id);
        },
      ),
    ],
  );
});
