import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  runApp(MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  final result = await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );

  if (result) {
    service.start();
  }
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "My App Service",
      content: "Updated at ${DateTime.now()}",
    );

    service.sendData(
      {"current_date": DateTime.now().toIso8601String()},
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: Column(
          children: [
            StreamBuilder<Map<String, dynamic>?>(
              stream: FlutterBackgroundService().onDataReceived,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data = snapshot.data!;
                DateTime? date = DateTime.tryParse(data["current_date"]);
                return Text(date.toString());
              },
            ),
            ElevatedButton(
              child: Text("Foreground Mode"),
              onPressed: () {
                FlutterBackgroundService()
                    .sendData({"action": "setAsForeground"});
              },
            ),
            ElevatedButton(
              child: Text("Background Mode"),
              onPressed: () {
                FlutterBackgroundService()
                    .sendData({"action": "setAsBackground"});
              },
            ),
            ElevatedButton(
              child: Text(text),
              onPressed: () async {
                final service = FlutterBackgroundService();
                var isRunning = await service.isServiceRunning();
                if (isRunning) {
                  service.sendData(
                    {"action": "stopService"},
                  );
                } else {
                  service.start();
                }

                if (!isRunning) {
                  text = 'Stop Service';
                } else {
                  text = 'Start Service';
                }
                setState(() {});
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FlutterBackgroundService().sendData({
              "hello": "world",
            });
          },
          child: Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
