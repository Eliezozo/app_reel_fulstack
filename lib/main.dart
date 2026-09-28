import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/storage/hive_cache_store.dart';
import 'core/storage/hive_token_storage.dart';
import 'core/storage/storage_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final authBox = await Hive.openBox<String>(HiveBoxes.auth);
  final cacheBox = await Hive.openBox<String>(HiveBoxes.cache);
  runApp(
    ProviderScope(
      overrides: [
        tokenStorageProvider.overrideWithValue(HiveTokenStorage(authBox)),
        cacheStoreProvider.overrideWithValue(HiveCacheStore(cacheBox)),
      ],
      child: const AgriBoardApp(),
    ),
  );
}
