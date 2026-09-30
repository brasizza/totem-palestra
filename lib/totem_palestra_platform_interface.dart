import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'totem_palestra_pigeon.dart';

abstract class TotemPalestraPlatform extends PlatformInterface {
  
  TotemPalestraPlatform() : super(token: _token);

  static final Object _token = Object();

  static TotemPalestraPlatform _instance = PigeonTotemPalestra();
  
  static TotemPalestraPlatform get instance => _instance;
  
  static set instance(TotemPalestraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> printLine(String text) {
    throw UnimplementedError('printLine() has not been implemented.');
  }
}
