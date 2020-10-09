import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterBackgroundService {
  bool _isFromInitialization = false;
  static const MethodChannel _backgroundChannel = const MethodChannel(
      'id.flutter/background_service_bg', JSONMethodCodec());

  static const MethodChannel _mainChannel =
      const MethodChannel('id.flutter/background_service', JSONMethodCodec());

  static FlutterBackgroundService _instance =
      FlutterBackgroundService._internal().._setupBackground();
  FlutterBackgroundService._internal();
  factory FlutterBackgroundService() => _instance;

  void _setupMain() {
    _isFromInitialization = true;
    _mainChannel.setMethodCallHandler(_handle);
  }

  void _setupBackground() {
    _backgroundChannel.setMethodCallHandler(_handle);
  }

  Future<dynamic> _handle(MethodCall call) async {
    switch (call.method) {
      case "onReceiveData":
        _streamController.sink.add(call.arguments);
        break;
      default:
    }

    return true;
  }

  static Future<bool> initialize(
    Function onStart, {
    bool foreground = true,
  }) async {
    final CallbackHandle handle = PluginUtilities.getCallbackHandle(onStart);
    if (handle == null) {
      return false;
    }

    final service = FlutterBackgroundService();
    service._setupMain();

    final r = await _mainChannel.invokeMethod(
      "BackgroundService.start",
      {
        "handle": handle.toRawHandle(),
        "is_foreground_mode": foreground,
      },
    );

    return r ?? false;
  }

  // Send data from UI to Service, or from Service to UI
  void sendData(Map<String, dynamic> data) async {
    if (_isFromInitialization) {
      _mainChannel.invokeMethod("sendData", data);
      return;
    }

    _backgroundChannel.invokeMethod("sendData", data);
  }

  // Set Foreground Notification Information
  // Only available when foreground mode is true
  void setNotificationInfo({String title, String content}) {
    if (Platform.isAndroid)
      _backgroundChannel.invokeMethod("setNotificationInfo", {
        "title": title,
        "content": content,
      });
  }

  // Set Foreground Mode
  // Only for Android
  void setForegroundMode(bool value) {
    if (Platform.isAndroid)
      _backgroundChannel.invokeMethod("setForegroundMode", {
        "value": value,
      });
  }

  StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get onDataReceived => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
