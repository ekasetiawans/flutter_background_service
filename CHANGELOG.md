## 0.2.5
* FIX: (iOS) using other plugins
## 0.2.4
* FIX: (Android) run service background when charger not connected and screen lock (#92)
## 0.2.3
* ADDED: Using `BGTaskScheduler` on iOS 13. See readme for configuration.
## 0.2.2
* ADDED: `autoStart` to `IosConfiguration` 
## 0.2.1
* UPDATE README
* UPDATE: Flutter Version Constraint
## 0.2.0+1
* UPDATE README

## 0.2.0
* [BREAKING]: FlutterBackgroundService.initialize renamed to FlutterBackgroundService.configure
* [BREAKING]: use FlutterBackgroundService.start to start or restart after you call stopService.
* [ADDED]: IOS Background fetch is now supported you have to enable background fetch from xcode.
## 0.1.7

* Fix : cannot start service on android 12
* Fix : not started on boot completed
## 0.1.6

* Android 12 Compatibility Changes 
## 0.1.5

* Rollback foreground notification importance
## 0.1.4

* fixes UnsatisfiedLinkError when running as foreground service with autostart #32
## 0.1.3

* Fix notification not showing on android 7 and prior (Issue #26)
## 0.1.2

* Open app from notification (Issue #30)
## 0.1.1

* Fix #29 (DartVM not terminated when service stop)

## 0.1.0

* Bump flutter 2

## 0.1.0-nullsafety.2

* Fix #23

## 0.1.0-nullsafety.1

* Added isServiceRunning on iOS (issue #19)

## 0.1.0-nullsafety.0

* Added support to nullsafety

## 0.0.1+18

* Added stopService Method(Currently Works on Android Only).

## 0.0.1+17

* Add preference autoStart on Boot, default is true.

## 0.0.1+16

* Set Foreground Mode to false will remove notification. BugFix #4.

## 0.0.1+15

* Add ability to change Background or Foreground mode (Android Only)

## 0.0.1+14

* Bugfix BootReceiver

## 0.0.1+13

* Update example for iOS support.

## 0.0.1+12

* Start service immediately after initialize

## 0.0.1+11

* iOS

## 0.0.1+10

* bug fix

## 0.0.1+9

* bug fix

## 0.0.1+8

* bug fix

## 0.0.1+7

* Add ability to send data from UI to Service

## 0.0.1+6

* Improve stability

## 0.0.1+5

* Add ability to send data from service to UI

## 0.0.1+4

* Update README

## 0.0.1+3

* Add ability to change notification info (Android foreground service)

## 0.0.1+2

* Fix android missing plugin implementation

## 0.0.1+1

* Fix android build

## 0.0.1

* TODO: Describe initial release.