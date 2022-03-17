import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

class FlutterBackgroundServiceIOS extends FlutterBackgroundServicePlatform {
  /// Registers this class as the default instance of [FlutterBackgroundServicePlatform].
  static void registerWith() {
    FlutterBackgroundServicePlatform.instance = FlutterBackgroundServiceIOS();
  }

  bool _isFromInitialization = false;
  bool _isRunning = false;
  bool _isMainChannel = false;
  static const MethodChannel _backgroundChannel = const MethodChannel(
    'id.flutter/background_service_bg',
    JSONMethodCodec(),
  );

  static const MethodChannel _mainChannel = const MethodChannel(
    'id.flutter/background_service',
    JSONMethodCodec(),
  );

  void setupAsMain() {
    _isFromInitialization = true;
    _isRunning = true;
    _isMainChannel = true;
    _mainChannel.setMethodCallHandler(_handle);
  }

  void setupAsBackground() {
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

  Future<bool> start() async {
    if (!_isMainChannel) {
      throw Exception(
          'This method only allowed from UI. Please call configure() first.');
    }

    final result = await _mainChannel.invokeMethod('start');
    return result ?? false;
  }

  Future<bool> configure({
    required IosConfiguration iosConfiguration,
    required AndroidConfiguration androidConfiguration,
  }) async {
    final CallbackHandle? backgroundHandle =
        PluginUtilities.getCallbackHandle(iosConfiguration.onBackground);
    if (backgroundHandle == null) {
      return false;
    }

    final CallbackHandle? foregroundHandle =
        PluginUtilities.getCallbackHandle(iosConfiguration.onForeground);
    if (foregroundHandle == null) {
      return false;
    }

    final service = FlutterBackgroundServiceIOS();
    service.setupAsMain();

    final result = await _mainChannel.invokeMethod(
      "configure",
      {
        "background_handle": backgroundHandle.toRawHandle(),
        "foreground_handle": foregroundHandle.toRawHandle(),
        "auto_start": iosConfiguration.autoStart,
      },
    );

    return result ?? false;
  }

  // Send data from UI to Service, or from Service to UI
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
  void setNotificationInfo({String? title, String? content}) {
    // no-op
  }

  // Set Foreground Mode
  // Only for Android
  void setForegroundMode(bool value) {
    // no-op
  }

  Future<bool> isServiceRunning() async {
    if (_isMainChannel) {
      var result = await _mainChannel.invokeMethod("isServiceRunning");
      return result ?? false;
    } else {
      return _isRunning;
    }
  }

  // StopBackgroundService from Running
  void stopBackgroundService() {
    _backgroundChannel.invokeMethod("stopService");
    _isRunning = false;
  }

  void setAutoStartOnBootMode(bool value) {
    // no-op
  }

  StreamController<Map<String, dynamic>?> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>?> get onDataReceived => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
