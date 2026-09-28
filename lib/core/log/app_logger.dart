import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

class AppLogger {
  const AppLogger._();

  static void debug(String message) {
    debugPrint('${AppConfig.logTag} $message');
  }
}
