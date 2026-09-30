import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/src/main/kotlin/com/example/totem_palestra/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.totem_palestra'),
    dartPackageName: 'totem_palestra',
  ),
)
@HostApi()
abstract class TotemPalestraHostApi {
  String getPlatformVersion();

  void printLine(String text);
}
