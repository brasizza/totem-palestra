import 'package:flutter/foundation.dart';

import 'src/messages.g.dart';
import 'totem_palestra_platform_interface.dart';

/// An implementation of [TotemPalestraPlatform] that uses Pigeon.
class PigeonTotemPalestra extends TotemPalestraPlatform {
  PigeonTotemPalestra({@visibleForTesting TotemPalestraHostApi? api})
      : _api = api ?? TotemPalestraHostApi();

  /// The Pigeon-generated API used to interact with the native platform.
  final TotemPalestraHostApi _api;

  @override
  Future<String?> getPlatformVersion() {
    return _api.getPlatformVersion();
  }

  @override
  Future<void> printLine(String text) {
    return _api.printLine(text);
  }
}
