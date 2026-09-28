import 'package:connectivity_plus/connectivity_plus.dart';

import '../log/app_logger.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class ConnectivityNetworkInfo implements NetworkInfo {
  ConnectivityNetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (error) {
      AppLogger.debug('Connectivité indisponible: $error');
      return true;
    }
  }
}
