import 'package:flutter_test/flutter_test.dart';
import 'package:totem_palestra/totem_palestra.dart';
import 'package:totem_palestra/totem_palestra_platform_interface.dart';
import 'package:totem_palestra/totem_palestra_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTotemPalestraPlatform
    with MockPlatformInterfaceMixin
    implements TotemPalestraPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TotemPalestraPlatform initialPlatform = TotemPalestraPlatform.instance;

  test('$MethodChannelTotemPalestra is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTotemPalestra>());
  });

  test('getPlatformVersion', () async {
    TotemPalestra totemPalestraPlugin = TotemPalestra();
    MockTotemPalestraPlatform fakePlatform = MockTotemPalestraPlatform();
    TotemPalestraPlatform.instance = fakePlatform;

    expect(await totemPalestraPlugin.getPlatformVersion(), '42');
  });
}
