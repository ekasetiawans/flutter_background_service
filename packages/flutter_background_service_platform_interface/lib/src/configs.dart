class IosConfiguration {
  /// must be a top level or static method
  /// this method will be executed when app is in foreground
  final Function onForeground;

  /// must be a top level or static method
  /// this method will be executed by background fetch
  /// make sure you don't execute long running task there because of limitations on ios
  /// recommended maximum executed duration is only 15-20 seconds.
  final Function onBackground;

  /// wheter service auto start after configure.
  final bool autoStart;

  IosConfiguration({
    required this.onForeground,
    required this.onBackground,
    this.autoStart = true,
  });
}

class AndroidConfiguration {
  /// must be a top level or static method
  final Function onStart;

  /// wheter service can started automatically on boot and after configure
  final bool autoStart;

  /// wheter service is foreground or background mode
  final bool isForegroundMode;

  final String? foregroundServiceNotificationTitle;
  final String? foregroundServiceNotificationContent;

  AndroidConfiguration({
    required this.onStart,
    this.autoStart = true,
    required this.isForegroundMode,
    this.foregroundServiceNotificationContent,
    this.foregroundServiceNotificationTitle,
  });
}
