import 'package:flutter_test/flutter_test.dart';
import 'package:totem_palestra/totem_palestra.dart';
import 'package:totem_palestra/totem_palestra_platform_interface.dart';
import 'package:totem_palestra/totem_palestra_pigeon.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTotemPalestraPlatform
    with MockPlatformInterfaceMixin
    implements TotemPalestraPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  final printedLines = <String>[];

  @override
  Future<void> printLine(String text) async => printedLines.add(text);
}

void main() {
  final TotemPalestraPlatform initialPlatform = TotemPalestraPlatform.instance;

  test('$PigeonTotemPalestra is the default instance', () {
    expect(initialPlatform, isInstanceOf<PigeonTotemPalestra>());
  });

  test('getPlatformVersion', () async {
    TotemPalestra totemPalestraPlugin = TotemPalestra();
    MockTotemPalestraPlatform fakePlatform = MockTotemPalestraPlatform();
    TotemPalestraPlatform.instance = fakePlatform;

    expect(await totemPalestraPlugin.getPlatformVersion(), '42');
  });

  test('printLine', () async {
    TotemPalestra totemPalestraPlugin = TotemPalestra();
    MockTotemPalestraPlatform fakePlatform = MockTotemPalestraPlatform();
    TotemPalestraPlatform.instance = fakePlatform;

    await totemPalestraPlugin.printLine('Hello');
    expect(fakePlatform.printedLines, ['Hello']);
  });
}
