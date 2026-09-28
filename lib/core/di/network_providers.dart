import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/session_bus.dart';
import '../storage/storage_providers.dart';

final sessionBusProvider = Provider<SessionBus>((ref) => SessionBus());

final networkInfoProvider = Provider<NetworkInfo>(
  (ref) => ConnectivityNetworkInfo(Connectivity()),
);

final dioProvider = Provider<Dio>((ref) {
  return createDio(
    tokenStorage: ref.watch(tokenStorageProvider),
    sessionBus: ref.watch(sessionBusProvider),
  );
});
