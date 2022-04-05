# flutter_background_service

A flutter plugin for execute dart code in background.

## Android

- No additional setting is required.
- To change notification icon, just add drawable icon with name `ic_bg_service_small`.

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

## Do you like my work?

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/ekasetiawans)