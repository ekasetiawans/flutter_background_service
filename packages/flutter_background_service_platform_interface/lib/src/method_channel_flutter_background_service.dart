import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

class MethodChannelFlutterBackgroundService
    implements FlutterBackgroundServicePlatform {
  bool _isFromInitialization = false;
  bool _isRunning = false;
  bool _isMainChannel = false;

  static const MethodChannel _backgroundChannel = MethodChannel(
    'id.flutter/background_service_bg',
    JSONMethodCodec(),
  );

  static const MethodChannel _mainChannel = MethodChannel(
    'id.flutter/background_service',
    JSONMethodCodec(),
  );

  static final MethodChannelFlutterBackgroundService _instance =
      MethodChannelFlutterBackgroundService._internal().._setupBackground();

  MethodChannelFlutterBackgroundService._internal();
  factory MethodChannelFlutterBackgroundService() => _instance;

  void _setupMain() {
    _isFromInitialization = true;
    _isRunning = true;
    _isMainChannel = true;
    _mainChannel.setMethodCallHandler(_handle);
  }

  void _setupBackground() {
    _isRunning = true;
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

  @override
  Future<bool> start() async {
    if (!_isMainChannel) {
      throw Exception(
          'This method only allowed from UI. Please call configure() first.');
    }

    final result = await _mainChannel.invokeMethod('start');
    return result ?? false;
  }

  // Send data from UI to Service, or from Service to UI
  @override
  void sendData(Map<String, dynamic> data) async {
    if (!(await (isServiceRunning()))) {
      dispose();
      return;
    }

    if (_isFromInitialization) {
      _mainChannel.invokeMethod("sendData", data);
      return;
    }

    _backgroundChannel.invokeMethod("sendData", data);
  }

  // Set Foreground Notification Information
  // Only available when foreground mode is true
  @override
  void setNotificationInfo({String? title, String? content}) {
    _backgroundChannel.invokeMethod("setNotificationInfo", {
      "title": title,
      "content": content,
    });
  }

  // Set Foreground Mode
  // Only for Android
  @override
  void setForegroundMode(bool value) {
    _backgroundChannel.invokeMethod("setForegroundMode", {
      "value": value,
    });
  }

  @override
  Future<bool> isServiceRunning() async {
    if (_isMainChannel) {
      var result = await _mainChannel.invokeMethod("isServiceRunning");
      return result ?? false;
    } else {
      return _isRunning;
    }
  }

  // StopBackgroundService from Running
  @override
  void stopBackgroundService() {
    _backgroundChannel.invokeMethod("stopService");
    _isRunning = false;
  }

  @override
  void setAutoStartOnBootMode(bool value) {
    _backgroundChannel.invokeMethod("setAutoStartOnBootMode", {
      "value": value,
    });
  }

  final StreamController<Map<String, dynamic>?> _streamController =
      StreamController.broadcast();

  @override
  Stream<Map<String, dynamic>?> get onDataReceived => _streamController.stream;

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  Future<bool> configure({required IosConfiguration iosConfiguration, required AndroidConfiguration androidConfiguration}) {
    // TODO: implement configure
    throw UnimplementedError();
  }
}
