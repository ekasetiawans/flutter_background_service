import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);
  runApp(MyApp());
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  Timer.periodic(Duration(seconds: 1), (timer) {
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
