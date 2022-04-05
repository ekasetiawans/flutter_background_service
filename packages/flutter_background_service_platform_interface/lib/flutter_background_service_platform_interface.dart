import 'dart:async';

import 'package:flutter_background_service_platform_interface/src/configs.dart';
import 'package:flutter_background_service_platform_interface/src/method_channel_flutter_background_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/configs.dart';

abstract class Observable {
  void invoke(String method, [Map<String, dynamic>? args]);
  Stream<Map<String, dynamic>?> on(String method);
}

abstract class FlutterBackgroundServicePlatform extends PlatformInterface
    implements Observable {
  FlutterBackgroundServicePlatform() : super(token: _token);
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

  Future<bool> isServiceRunning();
}

abstract class ServiceInstance implements Observable {
  /// Stop the service
  Future<void> stopSelf();
}
