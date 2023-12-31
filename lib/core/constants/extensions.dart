// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';

extension IntegerExtensions on int {
  String toOrdinalText() {
    return this == 0
        ? 'Zeroth'
        : this == 1
            ? 'First'
            : this == 2
                ? 'Second'
                : this == 3
                    ? 'Third'
                    : this == 4
                        ? 'Fourth'
                        : this == 5
                            ? 'Fifth'
                            : 'Unhandled';
  }
}

extension StringExtension on String {
  toSentenceCase() {
    return '${substring(0, 1).toUpperCase()}${substring(1, (length))}';
  }
}

extension AppCoreDateTimeExtensions on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  bool isCacheStale([Duration cacheDuration = Duration.zero]) {
    bool value = false;
    value = -difference(DateTime.now()).inSeconds > cacheDuration.inSeconds;
    return value;
  }
}

///this returns the width and height dimensions of a text as a size.
Size measure(String text, TextStyle style,
    {int maxLines = 1, TextDirection direction = TextDirection.ltr}) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: direction)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

extension AppCoreGeneralExtension on Object? {
  bool isNull() {
    return this == null;
  }
}
