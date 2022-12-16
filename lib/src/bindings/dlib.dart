import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as dart_path;

const Set<String> _supported = {'linux', 'mac', 'win'};
String pathToBinaries = '';

String get binaryName {
  String os, ext;
  if (Platform.isLinux) {
    os = 'linux';
    ext = 'so';
  } else if (Platform.isMacOS) {
    os = 'mac';
    ext = 'so';
  } else if (Platform.isWindows) {
    os = 'win';
    ext = 'dll';
  } else {
    throw Exception('Unsupported platform!');
  }

  if (!_supported.contains(os)) {
    throw UnsupportedError('Unsupported platform: $os!');
  }

  return 'libtensorflowlite_c-$os.$ext';
}

/// TensorFlowLite C library.
// ignore: missing_return
DynamicLibrary tflitelib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open('libtensorflowlite_c.so');
  } else if (Platform.isIOS) {
    return DynamicLibrary.process();
  } else {
    var binaryPath = dart_path.join(pathToBinaries, binaryName); // '$pathToBinaries/$binaryName';
    var finalPath = dart_path.normalize(binaryPath);
    print(finalPath);
    return DynamicLibrary.open(finalPath);
  }
}();
