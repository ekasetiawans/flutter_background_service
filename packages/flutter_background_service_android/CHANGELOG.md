## 2.0.3

 - **FIX**: wakelock not released. ([e427f3b7](https://github.com/ekasetiawans/flutter_background_service/commit/e427f3b70138ec26f9671c2617f9061f25eade6f))

## 2.0.2

 - **FIX**: autoStartOnBootMode #160. ([16a785a3](https://github.com/ekasetiawans/flutter_background_service/commit/16a785a3cbcb4226321ddddf681b6554196fa4db))

## 2.0.1

 - **FIX**: release wakelock. ([c0830250](https://github.com/ekasetiawans/flutter_background_service/commit/c0830250b90a1ba6e2543a1bb25a13fba59a56b7))

## 2.0.0

 - Graduate package to a stable release. See pre-releases prior to this version for changelog entries.

## 2.0.0-dev.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: implement new concept. ([c8ce9c0b](https://github.com/ekasetiawans/flutter_background_service/commit/c8ce9c0bab82137dea031af124b84510286661f7))

## 1.0.2

 - **DOCS**: readme link. ([1479b91c](https://github.com/ekasetiawans/flutter_background_service/commit/1479b91cd80d637335de1314a528bcf51ebb7c0f))

## 1.0.1

 - **DOCS**: update README. ([fbf5e0ab](https://github.com/ekasetiawans/flutter_background_service/commit/fbf5e0abeeb9296ba32361b8af0a298ee9e71527))

## 0.0.2

 - **FEAT**: migrate to plugin platform interface. ([70e08ff0](https://github.com/ekasetiawans/flutter_background_service/commit/70e08ff03232c31946cc8eb7896f69c830f23322))

## 0.0.1+3

 - **FIX**: errors. ([13a6f841](https://github.com/ekasetiawans/flutter_background_service/commit/13a6f841f5d677ceb0010e8ba1bf9d7af53adbcf))

## 0.0.1+2

 - Update a dependency to the latest release.

## 0.0.1+1

 - **REFACTOR**: initialize melos.

## 0.2.6
* FIX: (Android) flutter initialization
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