import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retry/retry.dart';

final networkRetryProvider =
    Provider<NetworkRetry>((ref) => NetworkRetryImpl());

abstract class NetworkRetry {
  Future<T> networkRetry<T>(
    FutureOr<T> Function() function,
  );
}

class NetworkRetryImpl implements NetworkRetry {
  @override
  Future<T> networkRetry<T>(FutureOr<T> Function() function) {
    return retry(
      function,
      maxAttempts: 10,
      maxDelay: const Duration(seconds: 17),
    );
  }
}
