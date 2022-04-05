import 'dart:async';

import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

class MethodChannelFlutterBackgroundService
    implements FlutterBackgroundServicePlatform {
  @override
  Future<bool> configure(
      {required IosConfiguration iosConfiguration,
      required AndroidConfiguration androidConfiguration}) {
    // TODO: implement configure
    throw UnimplementedError();
  }

  @override
  void invoke(String method, [Map<String, dynamic>? args]) {
    // TODO: implement invoke
  }

  @override
  Future<bool> isServiceRunning() {
    // TODO: implement isServiceRunning
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>?> on(String method) {
    // TODO: implement on
    throw UnimplementedError();
  }

  @override
  Future<bool> start() {
    // TODO: implement start
    throw UnimplementedError();
  }
}
