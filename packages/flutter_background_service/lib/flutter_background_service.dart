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

  static FlutterBackgroundService _instance =
      FlutterBackgroundService._internal().._platform.setupAsBackground();
  FlutterBackgroundService._internal();
  factory FlutterBackgroundService() => _instance;

  /// Starts the background service.
  Future<bool> startService() => _platform.start();

  /// Send data from UI to Service, or from Service to UI
  /// the [data] will be received in [onDataReceived]
  void sendData(Map<String, dynamic> data) => _platform.sendData(data);

  /// Set Foreground Notification Information
  /// Only available for Foreground Service in Android.
  void setNotificationInfo({String? title, String? content}) =>
      _platform.setNotificationInfo(title: title, content: content);

  /// Set the service as foreground service.
  /// Foreground service requires a notification.
  /// Only for Android.
  void setAsForegroundService() => _platform.setForegroundMode(true);

  /// Set the service as background service.
  /// Only for Android.
  void setAsBackgroundService() => _platform.setForegroundMode(false);

  /// Wheter the service is running
  Future<bool> isRunning() => _platform.isServiceRunning();

  /// Stop the background service
  void stopService() => _platform.stopBackgroundService();

  /// Wheter service will started on boot
  void setAutoStartOnBootMode(bool value) =>
      _platform.setAutoStartOnBootMode(value);

  /// Receive data sent by [sendData].
  Stream<Map<String, dynamic>?> get onDataReceived => _platform.onDataReceived;

  /// Dispose the background service
  void dispose() => _platform.dispose();
}
