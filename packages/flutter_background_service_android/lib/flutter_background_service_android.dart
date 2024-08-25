library flutter_background_service_android;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service_platform_interface/flutter_background_service_platform_interface.dart';

bool _isMainIsolate = true;

@pragma('vm:entry-point')
Future<void> entrypoint(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  _isMainIsolate = false;

  final service = AndroidServiceInstance._();
  final int handle = int.parse(args.first);
  final callbackHandle = CallbackHandle.fromRawHandle(handle);
  final onStart = PluginUtilities.getCallbackFromHandle(callbackHandle);
  if (onStart != null) {
    onStart(service);
  }
}

class FlutterBackgroundServiceAndroid extends FlutterBackgroundServicePlatform {
  /// Registers this class as the default instance of [FlutterBackgroundServicePlatform].
  static void registerWith() {
    FlutterBackgroundServicePlatform.instance =
        FlutterBackgroundServiceAndroid();
  }

  FlutterBackgroundServiceAndroid._();
  static final FlutterBackgroundServiceAndroid _instance =
      FlutterBackgroundServiceAndroid._();

  factory FlutterBackgroundServiceAndroid() {
    if (!_isMainIsolate) {
      throw Exception(
        "This class should only be used in the main isolate (UI App)",
      );
    }

    return _instance;
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    debugPrint(call.method);

    switch (call.method) {
      case "onReceiveData":
        _controller.sink.add(call.arguments);
        break;
      default:
    }
  }

  Future<bool> start() async {
    final result = await _channel.invokeMethod('start');
    return result ?? false;
  }

  final MethodChannel _channel = MethodChannel(
    'id.flutter/background_service/android/method',
    JSONMethodCodec(),
  );

  final EventChannel _eventChannel = EventChannel(
    'id.flutter/background_service/android/event',
    JSONMethodCodec(),
  );

  StreamSubscription<dynamic>? _eventChannelListener;
  Future<bool> configure({
    required IosConfiguration iosConfiguration,
    required AndroidConfiguration androidConfiguration,
  }) async {
    _channel.setMethodCallHandler(_handleMethodCall);

    _eventChannelListener?.cancel();
    _eventChannelListener =
        _eventChannel.receiveBroadcastStream().listen((event) {
      _controller.sink.add(event);
    });

    final CallbackHandle? handle =
        PluginUtilities.getCallbackHandle(androidConfiguration.onStart);

    if (handle == null) {
      throw 'onStart method must be a top-level or static function';
    }

    List<AndroidForegroundType>? configForegroundServiceTypes =
        androidConfiguration.foregroundServiceTypes;
    List<String>? foregroundServiceTypes;
    if (configForegroundServiceTypes != null &&
        configForegroundServiceTypes.length > 0) {
      foregroundServiceTypes = [];
      androidConfiguration.foregroundServiceTypes!
          .forEach((foregroundServiceType) {
        foregroundServiceTypes!.add(foregroundServiceType.name);
      });
    }

    final result = await _channel.invokeMethod(
      "configure",
      {
        "background_handle": handle.toRawHandle(),
        "is_foreground_mode": androidConfiguration.isForegroundMode,
        "auto_start": androidConfiguration.autoStart,
        "auto_start_on_boot": androidConfiguration.autoStartOnBoot,
        "initial_notification_content":
            androidConfiguration.initialNotificationContent,
        "initial_notification_title":
            androidConfiguration.initialNotificationTitle,
        "notification_channel_id": androidConfiguration.notificationChannelId,
        "foreground_notification_id":
            androidConfiguration.foregroundServiceNotificationId,
        "foreground_service_types": foregroundServiceTypes,
      },
    );

    return result ?? false;
  }

  Future<bool> isServiceRunning() async {
    var result = await _channel.invokeMethod("isServiceRunning");
    return result ?? false;
  }

  final _controller = StreamController.broadcast(sync: true);

  void dispose() {
    _controller.close();
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
}

class AndroidServiceInstance extends ServiceInstance {
  static const MethodChannel _channel = const MethodChannel(
    'id.flutter/background_service_android_bg',
    JSONMethodCodec(),
  );

  AndroidServiceInstance._() {
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

  Future<void> setForegroundNotificationInfo({
    required String title,
    required String content,
  }) async {
    await _channel.invokeMethod("setNotificationInfo", {
      "title": title,
      "content": content,
    });
  }

  Future<void> setAsForegroundService() async {
    await _channel.invokeMethod("setForegroundMode", {
      'value': true,
    });
  }

  Future<void> setAsBackgroundService() async {
    await _channel.invokeMethod("setForegroundMode", {
      'value': false,
    });
  }

  /// returns true when the current Service instance is in foreground mode.
  Future<bool> isForegroundService() async {
    final result = await _channel.invokeMethod<bool>('isForegroundMode');
    return result ?? false;
  }

  Future<void> setAutoStartOnBootMode(bool value) async {
    await _channel.invokeMethod("setAutoStartOnBootMode", {
      "value": value,
    });
  }

  Future<bool> openApp() async {
    final result = await _channel.invokeMethod('openApp');
    return result ?? false;
  }
}
