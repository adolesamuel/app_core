import 'package:app_core/core/constants/constants.dart';
import 'package:app_core/core/constants/extensions.dart';
import 'package:app_core/core/failures/failure.dart';
import 'package:app_core/core/network_info/network_info.dart';
import 'package:app_core/core/runner/service.dart';
import 'package:fpdart/fpdart.dart';

class FetchPolicy {
  /// cacheAndNetwork
  /// Emit cached data first, if any, followed by data from
  /// the server, if the HTTP call succeeds.
  /// Useful for when the user first opens the
  /// app or page.
  // Stream<T> cacheAndNetwork<T>(Iterable<Future<T>> futures) async* {
  //   for (final future in futures) {
  //     var result = await future;
  //     yield result;
  //   }
  // }

  /// networkOnly,
  /// Don’t use the cache in any situation.
  /// If the server request fails,
  /// let the user know. Useful for when the user consciously
  /// refreshes the list.
  static Future<Either<Failure, T>> networkOnly<T>({
    required Future<T> Function() remoteSource,
    required NetworkInfo networkInfo,
    String? errorStrings,
  }) async {
    ServiceRunner<Failure, T> sR = ServiceRunner(networkInfo);

    final response = await sR.tryRemoteandCatch(
      call: remoteSource.call(),
      errorTitle: errorStrings ?? '',
    );

    return response;
  }

  /// networkFirst,
  /// Prefer using the server. If the request fails,
  /// try using the cache. If there isn’t anything in the cache,
  /// then let the user know an error occurred.
  /// Useful for when the user requests a subsequent page.
  static Future<Either<Failure, T>> networkFirst<T>({
    required Future<CacheModel<T>?> Function()? cacheSource,
    required Future<T> Function() remoteSource,
    required Future<bool> Function(T)? localSaveSource,
    //Conditions that will make cacheInvalid.
    bool Function(CacheModel<T>? data)? conditions,
    Duration? cacheAge,
    required NetworkInfo networkInfo,
    String? errorStrings,
  }) async {
    ServiceRunner<Failure, T> sR = ServiceRunner(networkInfo);

    final response = await sR.tryRemoteandCatch(
      call: remoteSource.call().then((value) async {
        final isSaved = await localSaveSource?.call(value);
        if (isSaved ?? true) {
          return value;
        } else {
          throw Exception('Not Saved');
        }
      }),
      errorTitle: errorStrings ?? '',
    );

    if (response.isLeft()) {
      final cacheData = await cacheSource?.call();
      bool isListEmpty = false;
      //Check if it's a list
      final isCachedDataAList = cacheData?.data is Iterable;
      if (isCachedDataAList) {
        final list = cacheData?.data as List;
        isListEmpty = list.isEmpty;
      }
      final isCacheInvalid = conditions?.call(cacheData) ?? false;

      if (cacheData == null ||
          cacheData.dateSaved
              .isCacheStale(cacheAge ?? AppCoreConstants.halfHrCacheAge) ||
          isListEmpty ||
          isCacheInvalid) {
        return response;
      } else {
        return Right(cacheData.data);
      }
    } else {
      return response;
    }
  }

  /// cacheFirst,
  /// Prefer using the cache. If there isn’t anything in the cache,
  /// try using the server.
  /// Useful for when the user clears a tag or the search box.
  static Future<Either<Failure, T>> cacheFirst<T>({
    required Future<CacheModel<T>?> Function()? cacheSource,
    required Future<T> Function() remoteSource,
    required Future<bool> Function(T)? localSaveSource,
    //Conditions that will make cacheInvalid.
    bool Function(CacheModel<T>? data)? conditions,
    Duration? cacheAge,
    required NetworkInfo networkInfo,
    String? errorStrings,
  }) async {
    ServiceRunner<Failure, T> sR = ServiceRunner(networkInfo);

    final cacheData = await cacheSource?.call();

    final isCacheInvalid = conditions?.call(cacheData) ?? false;

    bool isListEmpty = false;
    //Check if it's a list
    final isCachedDataAList = cacheData?.data is Iterable;
    if (isCachedDataAList) {
      final list = cacheData?.data as List;
      isListEmpty = list.isEmpty;
    }

    if ((cacheData == null ||
            cacheData.dateSaved
                .isCacheStale(cacheAge ?? AppCoreConstants.halfHrCacheAge)) ||
        isListEmpty ||
        isCacheInvalid) {
      return sR.tryRemoteandCatch(
          call: remoteSource.call().then((value) async {
            final isSaved = await localSaveSource?.call(value);
            if (isSaved ?? true) {
              return value;
            } else {
              throw Exception('Not Saved');
            }
          }),
          errorTitle: errorStrings ?? 'Error');
    } else {
      return Right(cacheData.data);
    }
  }
}

class CacheModel<T> {
  final T data;
  final DateTime dateSaved;

  CacheModel({
    required this.data,
    required this.dateSaved,
  });
}
