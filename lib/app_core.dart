library app_core;

import 'package:app_core/services/authmanager/authmanager.dart';
import 'package:app_core/services/authmanager/sources/local_source.dart';

class AppCore {
  static void initializeAppCore<Y>(AuthLocalDataSource<Y> localDataSource) {
    AuthManager.initializeLocalAuth<Y>(localDataSource);
  }
}

// void run() {
//   AppCore.initializeAppCore<AuthUser>(AuthImpl());
// }

// class AuthImpl implements AuthLocalDataSource<AuthUser> {
//   @override
//   Future<bool> clearAuthenticatedUser() {
//     // TODO: implement clearAuthenticatedUser
//     throw UnimplementedError();
//   }

//   @override
//   Future<AuthUser?> getAuthenticatedUser() {
//     // TODO: implement getAuthenticatedUser
//     throw UnimplementedError();
//   }

//   @override
//   Future<AuthUser> saveAuthenticatedUser(AuthUser authUser) {
//     // TODO: implement saveAuthenticatedUser
//     throw UnimplementedError();
//   }

//   @override
//   Stream<AuthUser?> streamUserStatus() {
//     // TODO: implement streamUserStatus
//     throw UnimplementedError();
//   }
// }

// class AuthUser {}
