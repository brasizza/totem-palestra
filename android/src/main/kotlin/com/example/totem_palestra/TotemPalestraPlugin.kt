package com.example.totem_palestra

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** TotemPalestraPlugin */
class TotemPalestraPlugin: FlutterPlugin, TotemPalestraHostApi {
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    TotemPalestraHostApi.setUp(flutterPluginBinding.binaryMessenger, this)
  }

  override fun getPlatformVersion(): String {
    return "Android ${android.os.Build.VERSION.RELEASE}"
  }

  override fun printLine(text: String) {
    GertecPrinter.printLine(text)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    TotemPalestraHostApi.setUp(binding.binaryMessenger, null)
  }
}
