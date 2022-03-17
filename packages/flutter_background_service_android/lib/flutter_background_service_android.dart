import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

class FlutterBackgroundServiceAndroid extends FlutterBackgroundServicePlatform {
  /// Registers this class as the default instance of [FlutterBackgroundServicePlatform].
  static void registerWith() {
    FlutterBackgroundServicePlatform.instance =
        FlutterBackgroundServiceAndroid();
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

  static FlutterBackgroundServiceAndroid _instance =
      FlutterBackgroundServiceAndroid._internal().._setupBackground();

  static Object token = Object();
  FlutterBackgroundServiceAndroid._internal() : super(token: token);

  factory FlutterBackgroundServiceAndroid() => _instance;

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
    final CallbackHandle? handle =
        PluginUtilities.getCallbackHandle(androidConfiguration.onStart);
    if (handle == null) {
      return false;
    }

    final service = FlutterBackgroundServiceAndroid();
    service._setupMain();
    final result = await _mainChannel.invokeMethod(
      "configure",
      {
        "handle": handle.toRawHandle(),
        "is_foreground_mode": androidConfiguration.isForegroundMode,
        "auto_start_on_boot": androidConfiguration.autoStart,
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
    if (Platform.isAndroid)
      _backgroundChannel.invokeMethod("setAutoStartOnBootMode", {
        "value": value,
      });
  }

  StreamController<Map<String, dynamic>?> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>?> get onDataReceived => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
