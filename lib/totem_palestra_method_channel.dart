import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'totem_palestra_platform_interface.dart';

/// An implementation of [TotemPalestraPlatform] that uses method channels.
class MethodChannelTotemPalestra extends TotemPalestraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('totem_palestra');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
