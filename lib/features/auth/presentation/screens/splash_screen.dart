import 'package:flutter/material.dart';

import '../../../../core/config/app_strings.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.background],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.eco, color: AppColors.primary, size: 56),
              SizedBox(height: 16),
              Text(
                AppStrings.appName,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              SizedBox(height: 8),
              Text(AppStrings.tagline, style: TextStyle(color: AppColors.textSecondary)),
              SizedBox(height: 28),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
