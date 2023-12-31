import 'package:app_core/services/authmanager/sources/local_source.dart';

class AuthManager<T> {
  static AuthManager instance = AuthManager._();
  late final AuthLocalDataSource<T> localSource;

  T? user;

  AuthManager._() {
    init();
  }

  static void initializeLocalAuth<T>(AuthLocalDataSource<T> localAuth) {
    AuthManager.instance.localSource = localAuth;
  }

  Future<void> init() async {
    user = await localSource.getAuthenticatedUser();
  }

  Future<T?> getAuthenticatedUser() async {
    return user = await localSource.getAuthenticatedUser();
  }

  Future<void> clearAuthenticatedUser() async {
    await localSource.clearAuthenticatedUser();
  }

  Stream<T?> streamActiveUser() async* {
    yield* localSource
        .streamUserStatus()
        .map((event) => user = event)
        .asBroadcastStream();
  }
}

// class AuthData {}
