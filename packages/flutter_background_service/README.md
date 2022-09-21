# flutter_background_service

A flutter plugin for execute dart code in background.

## Support me to maintain this plugin continously with a cup of coffee.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/ekasetiawans)

## Android

- No additional setting is required.
- To change notification icon, just add drawable icon with name `ic_bg_service_small`.

> **WARNING**: Starting from 2.3.0 the Service instance will be running on it's own android process (e.g com.package.your:background). It might be more difficult to debugging with breakpoints. Learn more about android process, read https://developer.android.com/guide/components/processes-and-threads.

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

## iOS

- Enable `background_fetch` capability in xcode (optional), if you wish ios to execute `IosConfiguration.onBackground` callback.

- For iOS 13 (using `BGTaskScheduler`), insert lines below into your ios/Runner/Info.plist

```plist
<key>BGTaskSchedulerPermittedIdentifiers</key>
<array>
    <string>dev.flutter.background.refresh</string>
</array>
```

## Usage

- Call `FlutterBackgroundService.configure` to configure handler that will be executed by the Service.
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

Make sure you had created notification icons named `ic_bg_service_small` and placed in res/drawable-mdpi, res/drawable-hdpi, res/drawable-hdpi, res/drawable-xxhdpi for PNGs file, and res/drawable-anydpi-v24 for XML (Vector) file (optional).

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