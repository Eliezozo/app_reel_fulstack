import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_strings.dart';
import '../error/app_exception.dart';
import '../result/cached_result.dart';
import 'error_state.dart';
import 'list_skeleton.dart';

class AsyncCachedBody<T> extends StatelessWidget {
  const AsyncCachedBody({
    required this.value,
    required this.onRetry,
    required this.dataBuilder,
    super.key,
  });

  final AsyncValue<CachedResult<T>> value;
  final VoidCallback onRetry;
  final Widget Function(CachedResult<T> result) dataBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => const ListSkeleton(),
      error: (error, _) => ErrorState(
        message: error is AppException ? error.message : AppStrings.genericError,
        onRetry: onRetry,
      ),
      data: dataBuilder,
    );
  }
}
