typedef Json = Map<String, dynamic>;

class AppCoreConstants {
  static const halfHrCacheAge = Duration(minutes: 30);
  static const oneMinuteCacheAge = Duration(minutes: 1);
  static const oneHourCacheAge = Duration(hours: 1);
  static const threeHourCacheAge = Duration(hours: 3);
  static const sixHourCacheAge = Duration(hours: 6);
  static const oneDayCacheAge = Duration(days: 1);
  static const veryLongCacheAge = Duration(days: 7);

  static const oneMinutePoll = Duration(minutes: 1);
}
