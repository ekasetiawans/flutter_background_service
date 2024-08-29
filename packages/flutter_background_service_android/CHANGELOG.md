## 6.2.7

 - **BUG**: service crash due to START_STICKY. ([a000a6ba](https://github.com/ekasetiawans/flutter_background_service/commit/a000a6bae974de543c9f37275e2aab177c197339))

## 6.2.6

 - Update a dependency to the latest release.

## 6.2.5

 - **FIX**: lints. ([7b63fca4](https://github.com/ekasetiawans/flutter_background_service/commit/7b63fca4e97941b2891570bd80701c7bb98cda23))

## 6.2.4

 - **FIX**: fix crash on android 14 after starting foreground service. ([4bdc46d9](https://github.com/ekasetiawans/flutter_background_service/commit/4bdc46d951febafbcbb2b118324cddc2b30ad752))

## 6.2.3

 - Update a dependency to the latest release.

## 6.2.2

 - **FIX**: android build error. ([8102e015](https://github.com/ekasetiawans/flutter_background_service/commit/8102e01563b967cea588a09b8a9773fc56b0dd2c))

## 6.2.1

 - **FIX**: checks methodChanel's nullabilty inside MainHandler.post. ([cd0d098f](https://github.com/ekasetiawans/flutter_background_service/commit/cd0d098f76fb9e211ab5db1a08f19cfd21827b30))
 - **FIX**: removes listener before turn methodChannel null. ([7909b51c](https://github.com/ekasetiawans/flutter_background_service/commit/7909b51cafbf6e79ad0f875e73889ad1b2b5fc34))

## 6.2.0

 - **FEAT**: throw an error if using FlutterBackgroundService class in worker isolate. ([9a5732ce](https://github.com/ekasetiawans/flutter_background_service/commit/9a5732cef65ce5b33e699569cd88c98521c002ac))

## 6.1.0

 - **FEAT**: throw an error if using FlutterBackgroundService class in worker isolate. ([d09843f8](https://github.com/ekasetiawans/flutter_background_service/commit/d09843f82a6d4a9ef19529ab27701ab68f68ee7c))

## 6.0.1

 - **FIX**: service do not connect to dart side after destroy by xiaomi boost memory. ([a04d3a75](https://github.com/ekasetiawans/flutter_background_service/commit/a04d3a75ca0a8e4683802b0a01e41b0dd50ba37b))

## 6.0.0

> Note: This release has breaking changes.

 - **REFACTOR**: improve android performances. ([13f73a86](https://github.com/ekasetiawans/flutter_background_service/commit/13f73a86e9c1cc0c5fc46a757992e24219d03715))
 - **REFACTOR**: remove unused methods. ([ea79ceda](https://github.com/ekasetiawans/flutter_background_service/commit/ea79cedac08089a3d6dafb8d7c785d73b753f80c))
 - **REFACTOR**: refactor java code. ([d7db0c09](https://github.com/ekasetiawans/flutter_background_service/commit/d7db0c092dcfc0af0bb8f1175ea82f3f0ccfe908))
 - **REFACTOR**: initialize melos. ([00bf06da](https://github.com/ekasetiawans/flutter_background_service/commit/00bf06da1ca1f4554edaabbd108c59f34b02c611))
 - **PERF**: improve entrypoint with args. ([5abacbe5](https://github.com/ekasetiawans/flutter_background_service/commit/5abacbe57f239d9ce1667e643d81d6b17f873f5c))
 - **PERF**: using exact alarm for watchdog receiver. ([6dba6670](https://github.com/ekasetiawans/flutter_background_service/commit/6dba6670965a24b9b0657ad0abc793db850a982b))
 - **PERF**: improve android background service. ([e01a3fa2](https://github.com/ekasetiawans/flutter_background_service/commit/e01a3fa2938479f31a525c23ff888c03b496fa70))
 - **FIX**: We still need to check service is running or not. ([280a603e](https://github.com/ekasetiawans/flutter_background_service/commit/280a603ee4fff39e2d0d0cd043dd6ba6f0941ee1))
 - **FIX**: Issue created by [#336](https://github.com/ekasetiawans/flutter_background_service/issues/336). ([6fedeed2](https://github.com/ekasetiawans/flutter_background_service/commit/6fedeed253d2648d876b9a2e3e5a30967934a81a))
 - **FIX**: added proguard for android plugin. ([0d7ac8a6](https://github.com/ekasetiawans/flutter_background_service/commit/0d7ac8a698b339af5931cb3b3e18c4b7f2e2670f))
 - **FIX**: make final variable for backward compatibility of gradle. ([d7087ba0](https://github.com/ekasetiawans/flutter_background_service/commit/d7087ba07a580e7d16d4e416cde43ddfb531e664))
 - **FIX**: using Runnable instead of lambda. ([9cda867d](https://github.com/ekasetiawans/flutter_background_service/commit/9cda867d8f2dc84cf1f7f112a3e87b1fa7dc1d3d))
 - **FIX**: wakelock not released. ([e427f3b7](https://github.com/ekasetiawans/flutter_background_service/commit/e427f3b70138ec26f9671c2617f9061f25eade6f))
 - **FIX**: autoStartOnBootMode [#160](https://github.com/ekasetiawans/flutter_background_service/issues/160). ([16a785a3](https://github.com/ekasetiawans/flutter_background_service/commit/16a785a3cbcb4226321ddddf681b6554196fa4db))
 - **FIX**: release wakelock. ([c0830250](https://github.com/ekasetiawans/flutter_background_service/commit/c0830250b90a1ba6e2543a1bb25a13fba59a56b7))
 - **FIX**: errors. ([13a6f841](https://github.com/ekasetiawans/flutter_background_service/commit/13a6f841f5d677ceb0010e8ba1bf9d7af53adbcf))
 - **FEAT**: added QUICKBOOT_POWERON action to intent-filter. ([46f08173](https://github.com/ekasetiawans/flutter_background_service/commit/46f08173cfb54795fb707bd521d8ed94db75cad5))
 - **FEAT**: revert to single process. ([515dde6a](https://github.com/ekasetiawans/flutter_background_service/commit/515dde6a49e50087c6f613ff0de8e1bd111a315b))
 - **FEAT**: move android service to separated process. ([bd2e6f07](https://github.com/ekasetiawans/flutter_background_service/commit/bd2e6f075ea8a7db231c7586b8f6244bb0399ff4))
 - **FEAT**(android): expose notification id for foreground service. ([47b7089c](https://github.com/ekasetiawans/flutter_background_service/commit/47b7089c5e4ab18f3a35558d6c7ec2d50fc8d3f1))
 - **FEAT**: using entrypoint instead of dart callback and added initial notification info for android. ([b0fc8f32](https://github.com/ekasetiawans/flutter_background_service/commit/b0fc8f32d59fa582c37fcd6e2349fab32aac245b))
 - **FEAT**: migrate to plugin platform interface. ([70e08ff0](https://github.com/ekasetiawans/flutter_background_service/commit/70e08ff03232c31946cc8eb7896f69c830f23322))
 - **DOCS**: update license. ([0c17e5de](https://github.com/ekasetiawans/flutter_background_service/commit/0c17e5dee091daa622470c8e3ba16c22ae03f8b3))
 - **DOCS**: readme link. ([1479b91c](https://github.com/ekasetiawans/flutter_background_service/commit/1479b91cd80d637335de1314a528bcf51ebb7c0f))
 - **DOCS**: update README. ([fbf5e0ab](https://github.com/ekasetiawans/flutter_background_service/commit/fbf5e0abeeb9296ba32361b8af0a298ee9e71527))
 - **BREAKING** **FEAT**: updated dependency constraints. ([97ef7977](https://github.com/ekasetiawans/flutter_background_service/commit/97ef7977ff9a2cb31b1e29593b3a9cc725d89e27))
 - **BREAKING** **FEAT**: autoStartOnBoot now using it's own argument. ([036669dc](https://github.com/ekasetiawans/flutter_background_service/commit/036669dc4383e938f09f88d9d8a248afbf918cf8))
 - **BREAKING** **FEAT**: implement new concept. ([c8ce9c0b](https://github.com/ekasetiawans/flutter_background_service/commit/c8ce9c0bab82137dea031af124b84510286661f7))

## 5.0.0

> Note: This release has breaking changes.

 - **REFACTOR**: improve android performances. ([13f73a86](https://github.com/ekasetiawans/flutter_background_service/commit/13f73a86e9c1cc0c5fc46a757992e24219d03715))
 - **REFACTOR**: remove unused methods. ([ea79ceda](https://github.com/ekasetiawans/flutter_background_service/commit/ea79cedac08089a3d6dafb8d7c785d73b753f80c))
 - **REFACTOR**: refactor java code. ([d7db0c09](https://github.com/ekasetiawans/flutter_background_service/commit/d7db0c092dcfc0af0bb8f1175ea82f3f0ccfe908))
 - **REFACTOR**: initialize melos. ([00bf06da](https://github.com/ekasetiawans/flutter_background_service/commit/00bf06da1ca1f4554edaabbd108c59f34b02c611))
 - **PERF**: improve entrypoint with args. ([5abacbe5](https://github.com/ekasetiawans/flutter_background_service/commit/5abacbe57f239d9ce1667e643d81d6b17f873f5c))
 - **PERF**: using exact alarm for watchdog receiver. ([6dba6670](https://github.com/ekasetiawans/flutter_background_service/commit/6dba6670965a24b9b0657ad0abc793db850a982b))
 - **PERF**: improve android background service. ([e01a3fa2](https://github.com/ekasetiawans/flutter_background_service/commit/e01a3fa2938479f31a525c23ff888c03b496fa70))
 - **FIX**: We still need to check service is running or not. ([280a603e](https://github.com/ekasetiawans/flutter_background_service/commit/280a603ee4fff39e2d0d0cd043dd6ba6f0941ee1))
 - **FIX**: Issue created by [#336](https://github.com/ekasetiawans/flutter_background_service/issues/336). ([6fedeed2](https://github.com/ekasetiawans/flutter_background_service/commit/6fedeed253d2648d876b9a2e3e5a30967934a81a))
 - **FIX**: added proguard for android plugin. ([0d7ac8a6](https://github.com/ekasetiawans/flutter_background_service/commit/0d7ac8a698b339af5931cb3b3e18c4b7f2e2670f))
 - **FIX**: make final variable for backward compatibility of gradle. ([d7087ba0](https://github.com/ekasetiawans/flutter_background_service/commit/d7087ba07a580e7d16d4e416cde43ddfb531e664))
 - **FIX**: using Runnable instead of lambda. ([9cda867d](https://github.com/ekasetiawans/flutter_background_service/commit/9cda867d8f2dc84cf1f7f112a3e87b1fa7dc1d3d))
 - **FIX**: wakelock not released. ([e427f3b7](https://github.com/ekasetiawans/flutter_background_service/commit/e427f3b70138ec26f9671c2617f9061f25eade6f))
 - **FIX**: autoStartOnBootMode [#160](https://github.com/ekasetiawans/flutter_background_service/issues/160). ([16a785a3](https://github.com/ekasetiawans/flutter_background_service/commit/16a785a3cbcb4226321ddddf681b6554196fa4db))
 - **FIX**: release wakelock. ([c0830250](https://github.com/ekasetiawans/flutter_background_service/commit/c0830250b90a1ba6e2543a1bb25a13fba59a56b7))
 - **FIX**: errors. ([13a6f841](https://github.com/ekasetiawans/flutter_background_service/commit/13a6f841f5d677ceb0010e8ba1bf9d7af53adbcf))
 - **FEAT**: added QUICKBOOT_POWERON action to intent-filter. ([46f08173](https://github.com/ekasetiawans/flutter_background_service/commit/46f08173cfb54795fb707bd521d8ed94db75cad5))
 - **FEAT**: revert to single process. ([515dde6a](https://github.com/ekasetiawans/flutter_background_service/commit/515dde6a49e50087c6f613ff0de8e1bd111a315b))
 - **FEAT**: move android service to separated process. ([bd2e6f07](https://github.com/ekasetiawans/flutter_background_service/commit/bd2e6f075ea8a7db231c7586b8f6244bb0399ff4))
 - **FEAT**(android): expose notification id for foreground service. ([47b7089c](https://github.com/ekasetiawans/flutter_background_service/commit/47b7089c5e4ab18f3a35558d6c7ec2d50fc8d3f1))
 - **FEAT**: using entrypoint instead of dart callback and added initial notification info for android. ([b0fc8f32](https://github.com/ekasetiawans/flutter_background_service/commit/b0fc8f32d59fa582c37fcd6e2349fab32aac245b))
 - **FEAT**: migrate to plugin platform interface. ([70e08ff0](https://github.com/ekasetiawans/flutter_background_service/commit/70e08ff03232c31946cc8eb7896f69c830f23322))
 - **DOCS**: update license. ([0c17e5de](https://github.com/ekasetiawans/flutter_background_service/commit/0c17e5dee091daa622470c8e3ba16c22ae03f8b3))
 - **DOCS**: readme link. ([1479b91c](https://github.com/ekasetiawans/flutter_background_service/commit/1479b91cd80d637335de1314a528bcf51ebb7c0f))
 - **DOCS**: update README. ([fbf5e0ab](https://github.com/ekasetiawans/flutter_background_service/commit/fbf5e0abeeb9296ba32361b8af0a298ee9e71527))
 - **BREAKING** **FEAT**: updated dependency constraints. ([97ef7977](https://github.com/ekasetiawans/flutter_background_service/commit/97ef7977ff9a2cb31b1e29593b3a9cc725d89e27))
 - **BREAKING** **FEAT**: autoStartOnBoot now using it's own argument. ([036669dc](https://github.com/ekasetiawans/flutter_background_service/commit/036669dc4383e938f09f88d9d8a248afbf918cf8))
 - **BREAKING** **FEAT**: implement new concept. ([c8ce9c0b](https://github.com/ekasetiawans/flutter_background_service/commit/c8ce9c0bab82137dea031af124b84510286661f7))

## 4.0.2

 - **FIX**: We still need to check service is running or not. ([280a603e](https://github.com/ekasetiawans/flutter_background_service/commit/280a603ee4fff39e2d0d0cd043dd6ba6f0941ee1))
 - **FIX**: Issue created by [#336](https://github.com/ekasetiawans/flutter_background_service/issues/336). ([6fedeed2](https://github.com/ekasetiawans/flutter_background_service/commit/6fedeed253d2648d876b9a2e3e5a30967934a81a))

## 4.0.1

 - **REFACTOR**: improve android performances. ([13f73a86](https://github.com/ekasetiawans/flutter_background_service/commit/13f73a86e9c1cc0c5fc46a757992e24219d03715))

## 4.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: updated dependency constraints. ([97ef7977](https://github.com/ekasetiawans/flutter_background_service/commit/97ef7977ff9a2cb31b1e29593b3a9cc725d89e27))

## 3.0.3

- **FIX**: Android crash when unbinding service

## 3.0.2

 - **FIX**: added proguard for android plugin. ([0d7ac8a6](https://github.com/ekasetiawans/flutter_background_service/commit/0d7ac8a698b339af5931cb3b3e18c4b7f2e2670f))

## 3.0.1

- **FIX**: Android crash when unbinding service

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: autoStartOnBoot now using it's own argument. ([036669dc](https://github.com/ekasetiawans/flutter_background_service/commit/036669dc4383e938f09f88d9d8a248afbf918cf8))

## 2.5.4

 - **REFACTOR**: remove unused methods. ([ea79ceda](https://github.com/ekasetiawans/flutter_background_service/commit/ea79cedac08089a3d6dafb8d7c785d73b753f80c))

## 2.5.3

 - **PERF**: improve entrypoint with args. ([5abacbe5](https://github.com/ekasetiawans/flutter_background_service/commit/5abacbe57f239d9ce1667e643d81d6b17f873f5c))

## 2.5.2

 - **PERF**: using exact alarm for watchdog receiver. ([6dba6670](https://github.com/ekasetiawans/flutter_background_service/commit/6dba6670965a24b9b0657ad0abc793db850a982b))

## 2.5.1

- **FIX**: Android crash when unbinding service

## 2.5.0

 - **FEAT**: added QUICKBOOT_POWERON action to intent-filter. ([46f08173](https://github.com/ekasetiawans/flutter_background_service/commit/46f08173cfb54795fb707bd521d8ed94db75cad5))

## 2.4.0

 - **FEAT**: revert to single process. ([515dde6a](https://github.com/ekasetiawans/flutter_background_service/commit/515dde6a49e50087c6f613ff0de8e1bd111a315b))

## 2.3.4

 - **REFACTOR**: refactor java code. ([d7db0c09](https://github.com/ekasetiawans/flutter_background_service/commit/d7db0c092dcfc0af0bb8f1175ea82f3f0ccfe908))

## 2.3.3

 - **FIX**: make final variable for backward compatibility of gradle. ([d7087ba0](https://github.com/ekasetiawans/flutter_background_service/commit/d7087ba07a580e7d16d4e416cde43ddfb531e664))

## 2.3.2

 - **FIX**: using Runnable instead of lambda. ([9cda867d](https://github.com/ekasetiawans/flutter_background_service/commit/9cda867d8f2dc84cf1f7f112a3e87b1fa7dc1d3d))
 - **DOCS**: update license. ([0c17e5de](https://github.com/ekasetiawans/flutter_background_service/commit/0c17e5dee091daa622470c8e3ba16c22ae03f8b3))
 - **DOCS**: updated README. ([3885e301](https://github.com/ekasetiawans/flutter_background_service/commit/3885e3017729a557b0b0b7ccdb968692ba7c8a52))

## 2.3.1

 - **DOCS**: update license. ([0c17e5de](https://github.com/ekasetiawans/flutter_background_service/commit/0c17e5dee091daa622470c8e3ba16c22ae03f8b3))

## 2.3.0

 - **FEAT**: move android service to separated process. ([bd2e6f07](https://github.com/ekasetiawans/flutter_background_service/commit/bd2e6f075ea8a7db231c7586b8f6244bb0399ff4))

## 2.2.2

 - Update a dependency to the latest release.

## 2.2.1

 - Update a dependency to the latest release.

## 2.2.0

 - **FEAT**: expose notification id for foreground service. ([47b7089c](https://github.com/ekasetiawans/flutter_background_service/commit/47b7089c5e4ab18f3a35558d6c7ec2d50fc8d3f1))

## 2.1.1

 - **PERF**: improve android background service. ([e01a3fa2](https://github.com/ekasetiawans/flutter_background_service/commit/e01a3fa2938479f31a525c23ff888c03b496fa70))

## 2.1.0

 - **FEAT**: using entrypoint instead of dart callback and added initial notification info for android. ([b0fc8f32](https://github.com/ekasetiawans/flutter_background_service/commit/b0fc8f32d59fa582c37fcd6e2349fab32aac245b))

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
