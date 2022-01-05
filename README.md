# flutter_background_service

A flutter plugin for execute dart code in background.

## Android

- No additional setting is required.
- To change notification icon, just add drawable icon with name `ic_bg_service_small`.

## iOS

- Enable `background_fetch` capability in xcode (optional), if you wise ios to execute `IosConfiguration.onBackground` callback.

## Usage

- Call `FlutterBackgroundService.configure` to configure handler that will be executed by the Service.
- Call `FlutterBackgroundService.start` to start the Service.

## Warning

The code will executed in isolated process, you can't share reference between UI and Service.
Use `sendData` and `onDataReceived` to communicate between service and UI.