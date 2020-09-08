import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterBackgroundService {
  static const MethodChannel _channel =
      const MethodChannel('id.flutter/background_service', JSONMethodCodec());

  static Future<bool> initialize(Function onStart) async {
    final CallbackHandle handle = PluginUtilities.getCallbackHandle(onStart);
    if (handle == null) {
      return false;
    }

    final r = await _channel.invokeMethod(
      "BackgroundService.start",
      handle.toRawHandle(),
    );

    return r ?? false;
  }
}
