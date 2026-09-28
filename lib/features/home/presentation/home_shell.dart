import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({required this.child, super.key});

  final Widget child;

  int _indexFor(String path) {
    if (path.startsWith('/markets')) return 1;
    if (path.startsWith('/news')) return 2;
    if (path.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final index = _indexFor(path);
    return Scaffold(
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          const routes = ['/weather', '/markets', '/news', '/profile'];
          context.go(routes[value]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: AppStrings.weatherTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: AppStrings.marketsTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: AppStrings.newsTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.profileTitle,
          ),
        ],
        ),
      ),
    );
  }
}
