import 'package:flutter_test/flutter_test.dart';
import 'package:totem_palestra/src/messages.g.dart';
import 'package:totem_palestra/totem_palestra_pigeon.dart';

class FakeTotemPalestraHostApi extends TotemPalestraHostApi {
  final printedLines = <String>[];

  @override
  Future<String> getPlatformVersion() async => '42';

  @override
  Future<void> printLine(String text) async => printedLines.add(text);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final api = FakeTotemPalestraHostApi();
  PigeonTotemPalestra platform = PigeonTotemPalestra(api: api);

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('printLine', () async {
    await platform.printLine('Hello');
    expect(api.printedLines, ['Hello']);
  });
}
