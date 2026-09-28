import 'package:flutter/material.dart';

import '../config/app_strings.dart';
import '../theme/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.warning.withValues(alpha: 0.16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          Icon(Icons.wifi_off, size: 18, color: AppColors.warning),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              AppStrings.offlineBanner,
              style: TextStyle(color: AppColors.warning, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
