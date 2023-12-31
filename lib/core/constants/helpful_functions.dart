import 'dart:io';

import 'package:flutter/foundation.dart';
import 'dart:async';

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class Throttler {
  final int milliseconds;

  Timer? timer;

  Throttler({required this.milliseconds});

  void run(VoidCallback action) {
    if (timer?.isActive ?? false) {
      return;
    }
    timer?.cancel();

    action();
    timer = Timer(Duration(milliseconds: milliseconds), () {});
  }

  void dispose() {
    timer?.cancel();
  }
}

String fileNameFromPath(String path) {
  final list = path.split('/');
  return list.last;
}

bool isPathForImage(String path) {
  List<String> imageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'tiff',
    'bmp',
    'heic',
  ];
  final extension = path.split('.').last;
  return imageExtensions.contains(extension.toLowerCase());
}

bool isFileImage(File file) {
  List<String> imageExtensions = [
    'png',
    'jpg',
    'jpeg',
    'gif',
    'tiff',
    'bmp',
    'heic',
  ];

  final extension = file.path.split('.').last;

  return imageExtensions.contains(extension.toLowerCase());
}
