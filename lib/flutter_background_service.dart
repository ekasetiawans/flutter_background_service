import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterBackgroundService {
  static const MethodChannel _channel = const MethodChannel(
    'id.flutter/background_service_bg',
    JSONMethodCodec(),
  );

  static FlutterBackgroundService _instance =
      FlutterBackgroundService._internal();
  FlutterBackgroundService._internal();
  factory FlutterBackgroundService() => _instance;

  static Future<bool> initialize(Function onStart) async {
    final CallbackHandle handle = PluginUtilities.getCallbackHandle(onStart);
    if (handle == null) {
      return false;
    }

    final _channel =
        MethodChannel('id.flutter/background_service', JSONMethodCodec());
    final r = await _channel.invokeMethod(
      "BackgroundService.start",
      handle.toRawHandle(),
    );

    return r ?? false;
  }

  void setNotificationInfo({String title, String content}) {
    _channel.invokeMethod("setNotificationInfo", {
      "title": title,
      "content": content,
    });
  }
}
