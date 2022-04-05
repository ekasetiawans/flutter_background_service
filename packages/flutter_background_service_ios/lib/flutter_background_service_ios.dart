import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

Future<void> _foregroundEntrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = IOSServiceInstance._();
  final int handle = await service._getForegroundHandler();
  final callbackHandle = CallbackHandle.fromRawHandle(handle);
  final onStart = PluginUtilities.getCallbackFromHandle(callbackHandle);
  if (onStart != null) {
    onStart(service);
  }
}

Future<void> _backgroundEntrypoint() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = IOSServiceInstance._();
  final int handle = await service._getBackgroundHandler();

  final callbackHandle = CallbackHandle.fromRawHandle(handle);
  final onStart = PluginUtilities.getCallbackFromHandle(callbackHandle)
      as FutureOr<bool> Function(ServiceInstance instance)?;
  if (onStart != null) {
    final result = await onStart(service);
    await service._setBackgroundFetchResult(result);
  }
}

class FlutterBackgroundServiceIOS extends FlutterBackgroundServicePlatform {
  /// Registers this class as the default instance of [FlutterBackgroundServicePlatform].
  static void registerWith() {
    FlutterBackgroundServicePlatform.instance = FlutterBackgroundServiceIOS();
  }

  static const MethodChannel _channel = const MethodChannel(
    'id.flutter/background_service_ios',
    JSONMethodCodec(),
  );

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
    final result = await _channel.invokeMethod('start');
    return result ?? false;
  }

  Future<bool> configure({
    required IosConfiguration iosConfiguration,
    required AndroidConfiguration androidConfiguration,
  }) async {
    _channel.setMethodCallHandler(_handle);

    final CallbackHandle? foregroundEntrypointHandle =
        PluginUtilities.getCallbackHandle(_foregroundEntrypoint);
    if (foregroundEntrypointHandle == null) {
      return false;
    }

    final CallbackHandle? backgroundEntrypointHandle =
        PluginUtilities.getCallbackHandle(_backgroundEntrypoint);
    if (backgroundEntrypointHandle == null) {
      return false;
    }

    final CallbackHandle? foregroundHandle =
        PluginUtilities.getCallbackHandle(iosConfiguration.onForeground);
    if (foregroundHandle == null) {
      return false;
    }

    final CallbackHandle? backgroundHandle =
        PluginUtilities.getCallbackHandle(iosConfiguration.onBackground);

    if (backgroundHandle == null) {
      return false;
    }

    final result = await _channel.invokeMethod(
      "configure",
      {
        "foreground_entrypoint_handle":
            foregroundEntrypointHandle.toRawHandle(),
        "background_entrypoint_handle":
            backgroundEntrypointHandle.toRawHandle(),
        "background_handle": backgroundHandle.toRawHandle(),
        "foreground_handle": foregroundHandle.toRawHandle(),
        "auto_start": iosConfiguration.autoStart,
      },
    );

    return result ?? false;
  }

  Future<bool> isServiceRunning() async {
    var result = await _channel.invokeMethod("isServiceRunning");
    return result ?? false;
  }

  final _streamController = StreamController.broadcast(sync: true);

  void dispose() {
    _streamController.close();
  }

  @override
  void invoke(String method, [Map<String, dynamic>? args]) {
    _channel.invokeMethod("sendData", {
      'method': method,
      'args': args,
    });
  }

  @override
  Stream<Map<String, dynamic>?> on(String method) {
    return _streamController.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (data['method'] == method) {
            sink.add(data['args']);
          }
        },
      ),
    );
  }
}

class IOSServiceInstance extends ServiceInstance {
  static const MethodChannel _channel = const MethodChannel(
    'id.flutter/background_service_ios_bg',
    JSONMethodCodec(),
  );

  IOSServiceInstance._() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  final _controller = StreamController.broadcast(sync: true);
  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onReceiveData":
        _controller.sink.add(call.arguments);
        break;
      default:
    }
  }

  @override
  void invoke(String method, [Map<String, dynamic>? args]) {
    _channel.invokeMethod('sendData', {
      'method': method,
      'args': args,
    });
  }

  @override
  Future<void> stopSelf() async {
    await _channel.invokeMethod("stopService");
  }

  @override
  Stream<Map<String, dynamic>?> on(String method) {
    return _controller.stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (data['method'] == method) {
            sink.add(data['args']);
          }
        },
      ),
    );
  }

  Future<int> _getForegroundHandler() async {
    return await _channel.invokeMethod('getForegroundHandler');
  }

  Future<int> _getBackgroundHandler() async {
    return await _channel.invokeMethod('getBackgroundHandler');
  }

  Future<void> _setBackgroundFetchResult(bool value) async {
    await _channel.invokeMethod('setBackgroundFetchResult', value);
  }
}
