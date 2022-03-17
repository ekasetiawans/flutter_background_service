import 'dart:async';

import 'package:flutter_background_service_platform_interface/src/configs.dart';
import 'package:flutter_background_service_platform_interface/src/method_channel_flutter_background_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/configs.dart';

abstract class FlutterBackgroundServicePlatform extends PlatformInterface {
  
  FlutterBackgroundServicePlatform({required Object token})
      : super(token: token);

  static final Object _token = Object();

  static FlutterBackgroundServicePlatform _instance =
      MethodChannelFlutterBackgroundService();

  static FlutterBackgroundServicePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [FlutterBackgroundServicePlatform] when they register themselves.
  static set instance(FlutterBackgroundServicePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  Future<bool> configure({
    required IosConfiguration iosConfiguration,
    required AndroidConfiguration androidConfiguration,
  });

  Future<bool> start();

  // Send data from UI to Service, or from Service to UI
  void sendData(Map<String, dynamic> data);

  // Set Foreground Notification Information
  // Only available when foreground mode is true
  void setNotificationInfo({String? title, String? content});

  // Set Foreground Mode
  // Only for Android
  void setForegroundMode(bool value);

  Future<bool> isServiceRunning();

  // StopBackgroundService from Running
  void stopBackgroundService();

  void setAutoStartOnBootMode(bool value);

  final StreamController<Map<String, dynamic>?> _streamController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>?> get onDataReceived => _streamController.stream;

  void dispose() {
    _streamController.close();
  }
}
