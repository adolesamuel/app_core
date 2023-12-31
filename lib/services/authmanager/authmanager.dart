import 'package:app_core/services/authmanager/sources/local_source.dart';

class AuthManager<T> {
  static AuthManager instance = AuthManager._();
  late final AuthLocalDataSource<T> _localSource;

  T? user;

  AuthManager._();

  Future<void> initializeLocalAuth(AuthLocalDataSource<T> localAuth) async {
    _localSource = localAuth;
    init();
  }

  Future<void> init() async {
    user = await _localSource.getAuthenticatedUser();
  }

  Future<T?> getAuthenticatedUser() async {
    return user = await _localSource.getAuthenticatedUser();
  }

  Future<void> clearAuthenticatedUser() async {
    await _localSource.clearAuthenticatedUser();
  }

  Stream<T?> streamActiveUser() async* {
    yield* _localSource
        .streamUserStatus()
        .map((event) => user = event)
        .asBroadcastStream();
  }
}

// class AuthData {}
