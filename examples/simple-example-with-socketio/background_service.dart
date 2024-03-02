import 'dart:async';
import 'dart:ui';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
 
  io.Socket socket = io.io('ws://10.0.2.2:5000', //specify your own socket ip and port
      io.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart VM
          .enableAutoConnect() // disable auto-connection
          .setExtraHeaders({'foo': 'bar'}) // optional
          .build()
  );
  socket.connect();
  socket.onConnect((_) {
    print('Connected. Socket ID: ${socket.id}');
    // Implement your socket logic here
    // For example, you can listen for events or send data
  });

  socket.onDisconnect((_) {
    print('Disconnected');
  });
  socket.on("event", (data) {
    //do something here 
  });
  service.on("stop").listen((event) {
    service.stopSelf();
    debugPrint("background process is now stopped");
  });

  service.on("start").listen((event) {});

  Timer.periodic(const Duration(seconds: 1), (timer) {
    socket.emit("clientData", "hello");
    print("service is successfully running ${DateTime.now().second}");
  });
}
