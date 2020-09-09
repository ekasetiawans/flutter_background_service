import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class FlutterBackgroundService {
  bool _isFromInitialization = false;
  static const MethodChannel _channel = const MethodChannel(
      'id.flutter/background_service_bg', JSONMethodCodec());

  static const MethodChannel _methodChannel =
      const MethodChannel('id.flutter/background_service', JSONMethodCodec());

  static FlutterBackgroundService _instance =
      FlutterBackgroundService._internal();
  FlutterBackgroundService._internal();
  factory FlutterBackgroundService() => _instance;

  void _setup() {
    _isFromInitialization = true;
    _methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "onReceiveData":
          _streamController.sink.add(call.arguments);
          break;
        default:
      }

      return true;
    });
  }

  static Future<bool> initialize(Function onStart) async {
    final CallbackHandle handle = PluginUtilities.getCallbackHandle(onStart);
    if (handle == null) {
      return false;
    }

    final service = FlutterBackgroundService();
    service._setup();

    final r = await _methodChannel.invokeMethod(
      "BackgroundService.start",
      handle.toRawHandle(),
    );

    return r ?? false;
  }

  // Send data to UI if available
  void sendData(Map<String, dynamic> data) async {
    if (_isFromInitialization) {
      throw Exception("Only allowed from service inside");
    }

    _channel.invokeMethod("sendData", data);
  }

  // Set Foreground Notification Information
  void setNotificationInfo({String title, String content}) {
    _channel.invokeMethod("setNotificationInfo", {
      "title": title,
      "content": content,
    });
  }

  StreamController<Map<String, dynamic>> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get onDataReceived => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
