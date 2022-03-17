import 'dart:io';

void main() {
  final pubspec = File('pubspec.yaml');
  final version = Platform.environment['RELEASE_VERSION'];

  var contents = pubspec.readAsStringSync();
  final reg = RegExp(r'version: (\d+.\d+.\d+)');
  final match = reg.firstMatch(contents);
  if (match != null) {
    contents = contents.replaceRange(
      match.start,
      match.end,
      'version: $version',
    );
    pubspec.writeAsStringSync(contents, flush: true);
  }
}
