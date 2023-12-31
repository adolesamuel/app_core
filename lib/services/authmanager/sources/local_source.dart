abstract class AuthLocalDataSource<T> {
  Future<T> saveAuthenticatedUser(T authUser);
  Future<bool> clearAuthenticatedUser();
  Future<T?> getAuthenticatedUser();
  Stream<T?> streamUserStatus();
}
