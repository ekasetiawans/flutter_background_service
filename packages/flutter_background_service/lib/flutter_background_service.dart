import 'dart:async';

import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

export 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart'
    show IosConfiguration, AndroidConfiguration;

class FlutterBackgroundService {
  FlutterBackgroundServicePlatform get _platform =>
      FlutterBackgroundServicePlatform.instance;

  Future<bool> configure({
    required IosConfiguration iosConfiguration,
    required AndroidConfiguration androidConfiguration,
  }) =>
      _platform.configure(
        iosConfiguration: iosConfiguration,
        androidConfiguration: androidConfiguration,
      );

  Future<bool> start() => _platform.start();

  // Send data from UI to Service, or from Service to UI
  void sendData(Map<String, dynamic> data) => _platform.sendData(data);

  // Set Foreground Notification Information
  // Only available when foreground mode is true
  void setNotificationInfo({String? title, String? content}) =>
      _platform.setNotificationInfo(title: title, content: content);

  // Set Foreground Mode
  // Only for Android
  void setForegroundMode(bool value) => _platform.setForegroundMode(value);

  Future<bool> isServiceRunning() => _platform.isServiceRunning();

  // StopBackgroundService from Running
  void stopBackgroundService() => _platform.stopBackgroundService();

  void setAutoStartOnBootMode(bool value) =>
      _platform.setAutoStartOnBootMode(value);

  Stream<Map<String, dynamic>?> get onDataReceived => _platform.onDataReceived;

  void dispose() => _platform.dispose();
}
