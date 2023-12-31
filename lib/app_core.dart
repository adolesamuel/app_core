library app_core;

import 'package:app_core/services/authmanager/authmanager.dart';
import 'package:app_core/services/authmanager/sources/local_source.dart';

class AppCore {
  /// To utilise app core you have to create an implementaion of the
  /// AuthLocalDataSource class with a type of User [AuthUser] object.
  /// Within the app you can always get the authenicated user by doing
  /// AuthManager.instance.user. Even though this returns dynamic.
  /// the instance of user is AuthUser. It returns dynamic because,
  /// you can't infer types on static methods in dart
  /// Use this example here for guidance:
  /// void run() {
  ///   AppCore.initializeAppCore<AuthUser>(AuthImpl());
  /// }

  /// class AuthImpl implements AuthLocalDataSource<AuthUser> {
  ///   @override
  ///   Future<bool> clearAuthenticatedUser() {
  ///     throw UnimplementedError();
  ///   }

  ///   @override
  ///   Future<AuthUser?> getAuthenticatedUser() {
  ///     throw UnimplementedError();
  ///   }

  ///  @override
  ///  Future<AuthUser> saveAuthenticatedUser(AuthUser authUser) {
  ///     throw UnimplementedError();
  ///   }

  ///   @override
  ///  Stream<AuthUser?> streamUserStatus() {
  ///    throw UnimplementedError();
  ///   }
  /// }

  /// class AuthUser {}
  static Future<void> initializeAppCore<Y>(
      AuthLocalDataSource<Y> localDataSource) async {
    await AuthManager.instance.initializeLocalAuth(localDataSource);
  }
}
