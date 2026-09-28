import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/home_shell.dart';
import '../../features/markets/presentation/screens/market_detail_screen.dart';
import '../../features/markets/presentation/screens/markets_screen.dart';
import '../../features/news/presentation/screens/news_detail_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/weather/presentation/screens/weather_detail_screen.dart';
import '../../features/weather/presentation/screens/weather_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final path = state.matchedLocation;
      final onAuthPage = path == '/login' || path == '/register';
      if (auth is AuthUnknown) return path == '/splash' ? null : '/splash';
      if (auth is AuthUnauthenticated) return onAuthPage ? null : '/login';
      if (onAuthPage || path == '/splash') return '/weather';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/weather',
            builder: (context, state) => const WeatherScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => WeatherDetailScreen(id: state.pathParameters['id'] ?? ''),
              ),
            ],
          ),
          GoRoute(
            path: '/markets',
            builder: (context, state) => const MarketsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => MarketDetailScreen(id: state.pathParameters['id'] ?? ''),
              ),
            ],
          ),
          GoRoute(
            path: '/news',
            builder: (context, state) => const NewsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => NewsDetailScreen(id: state.pathParameters['id'] ?? ''),
              ),
            ],
          ),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    _subscription = ref.listen<AuthState>(authControllerProvider, (previous, next) {
      notifyListeners();
    });
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
