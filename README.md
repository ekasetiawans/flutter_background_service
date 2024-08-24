A flutter plugin for execute dart code in background.

## Support me to maintain this plugin continously with a cup of coffee.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/ekasetiawans)

## Android

- To change notification icon, just add drawable icon with name `ic_bg_service_small`.

> **WARNING**:
>
> Please make sure your project already use the version of gradle tools below:
> - in android/build.gradle ```classpath 'com.android.tools.build:gradle:7.4.2'```
> - in android/build.gradle ```ext.kotlin_version = '1.8.10'```
> - in android/gradle/wrapper/gradle-wrapper.properties ```distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip```

### Configuration required for Foreground Services on Android 14+ (SDK 34)

Applications that target SDK 34 and use foreground services need to include some additional configuration to declare the type of foreground service they use:

* Determine the type or types of foreground service your app requires by consulting [the documentation](https://developer.android.com/about/versions/14/changes/fgs-types-required)

* Add the corresponding permission to your `android/app/src/main/AndroidManifest.xml` file:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" xmlns:tools="http://schemas.android.com/tools" package="com.example">
  ...
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
  <!--
    Permission to use here depends on the value you picked for foregroundServiceType - see the Android documentation.
    Eg, if you picked 'location', use 'android.permission.FOREGROUND_SERVICE_LOCATION'
  -->
  <!--
    If you need more than 1 type, you must separate each type by a pipe(|) symbol - see the Android documentation.
    Eg, android:foregroundServiceType="location|mediaPlayback"
  -->
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE_..." />
  <application
        android:label="example"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        ...>

        <activity
            android:name=".MainActivity"
            android:exported="true"
            ...>

        <!--Add this-->
        <service
            android:name="id.flutter.flutter_background_service.BackgroundService"
            android:foregroundServiceType="WhatForegroundServiceTypesDoYouWant"
        />
        <!--end-->

        ...
  ...
  </application>
</manifest>
```

* Add the corresponding foreground service types to your AndroidConfiguration class:
```dart
await service.configure(
    // IOS configuration
    androidConfiguration: AndroidConfiguration(
      ...
      // Add this
      foregroundServiceTypes: [AndroidForegroundType.WhatForegroundServiceTypeDoYouWant]
      // Example:
      // foregroundServiceTypes: [AndroidForegroundType.mediaPlayback]
    ),
  );
```

> **WARNING**:
> * YOU MUST MAKE SURE ANY REQUIRED PERMISSIONS TO BE GRANTED BEFORE YOU START THE SERVICE
> * THE TYPES YOU PUT IN foregroundServiceTypes, MUST BE DECLARED IN MANIFEST


### Using custom notification for Foreground Service
You can make your own custom notification for foreground service. It can give you more power to make notifications more attractive to users, for example adding progressbars, buttons, actions, etc. The example below is using [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) plugin, but you can use any other notification plugin. You can follow how to make it below:

- Notification Channel
```dart

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeService();

    runApp(MyApp());
}

// this will be used as notification channel id
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    notificationChannelId, // id
    'MY FOREGROUND SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,

      notificationChannelId: notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,
    ),
    ...
```

- Update notification info

```dart

Future<void> onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'COOL SERVICE',
          'Awesome ${DateTime.now()}',
          const NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannelId,
              'MY FOREGROUND SERVICE',
              icon: 'ic_bg_service_small',
              ongoing: true,
            ),
          ),
        );
      }
    }
  });
}
```


### Using Background Service Even when The Application Is Closed

You can use this feature in order to execute code in background.
Very useful to fetch realtime data from a server and push notifications.

> **Must Know**:
> *  ``` isForegroundMode: false ``` : The background mode requires running in release mode and requires disabling battery optimization so that the service stays up when the user closes the application.
> *  ``` isForegroundMode: true ``` : Displays a silent notification when used according to [Android's Policy](https://developer.android.com/develop/background-work/services)


- Simple implementation using Socket.io
```dart
import 'dart:async';
import 'dart:ui';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeService();

    runApp(MyApp());
}

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
  final socket = io.io("your-server-url", <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });
  socket.onConnect((_) {
    print('Connected. Socket ID: ${socket.id}');
    // Implement your socket logic here
    // For example, you can listen for events or send data
  });

  socket.onDisconnect((_) {
    print('Disconnected');
  });
   socket.on("event-name", (data) {
    //do something here like pushing a notification
  });
  service.on("stop").listen((event) {
    service.stopSelf();
    print("background process is now stopped");
  });

  service.on("start").listen((event) {});

  Timer.periodic(const Duration(seconds: 1), (timer) {
    socket.emit("event-name", "your-message");
    print("service is successfully running ${DateTime.now().second}");
  });
}
```

## iOS

- Enable `background_fetch` capability in xcode (optional), if you wish ios to execute `IosConfiguration.onBackground` callback.

- For iOS 13 and Later (using `BGTaskScheduler`), insert lines below into your ios/Runner/Info.plist

```plist
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>dev.flutter.background.refresh</string>
</array>
```

- You can also using your own custom identifier
In `ios/Runner/AppDelegate.swift` add line below

```swift
import UIKit
import Flutter
import flutter_background_service_ios // add this

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    /// Add this line
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## Usage

- Call `FlutterBackgroundService.configure()` to configure handler that will be executed by the Service.

> It's highly recommended to call this method in `main()` method to ensure the callback handler updated.

- Call `FlutterBackgroundService.start` to start the Service if `autoStart` is not enabled.

- Since the Service using Isolates, You won't be able to share reference between UI and Service. You can communicate between UI and Service using `invoke()` and `on(String method)`.

## Migration

- `sendData()` renamed to `invoke(String method)`
- `onDataReceived()` renamed to `on(String method)`
- Now you have to use `ServiceInstance` object inside `onStart` method instead of creating a new `FlutterBackgroundService` object. See the example project.
- Only use `FlutterBackgroundService` class in UI Isolate and `ServiceInstance` in background isolate.
## FAQ

### Why the service not started automatically?

Some android device manufacturers have a custom android os for example MIUI from Xiaomi. You have to deal with that policy.

### Service killed by system and not respawn?

Try to disable battery optimization for your app.

### My notification icon not changed, how to solve it?

Make sure you had created notification icons named `ic_bg_service_small` and placed in res/drawable-mdpi, res/drawable-hdpi, res/drawable-xhdpi, res/drawable-xxhdpi for PNGs file, and res/drawable-anydpi-v24 for XML (Vector) file.

### Service not running in Release Mode

Add `@pragma('vm:entry-point')` to the `onStart()` method.
Example:

```dart

@pragma('vm:entry-point')
void onStart(ServiceInstance service){
  ...
}
```

### Service terminated when app is in background (minimized) on iOS

Keep in your mind, iOS doesn't have a long running service feature like Android. So, it's not possible to keep your application running when it's in background because the OS will suspend your application soon. Currently, this plugin provide onBackground method, that will be executed periodically by `Background Fetch` capability provided by iOS. It cannot be faster than 15 minutes and only alive about 15-30 seconds.

## Discord

Click [here](https://discord.gg/aqk6JjBm) to join to my discord channels
