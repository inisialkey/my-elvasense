class ListAPI {
  ListAPI._(); // coverage:ignore-line

  /// Auth
  static const String generalToken = '/v1/api/auth/general';
  static const String refreshToken = '/v1/api/auth/refresh';
  static const String user = '/v1/api/user';
  static const String login = '/api/v1/sign-in';
  static const String logout = '/API/V1/user/logout';

  /// User
  static const String users = '/v1/api/user/all';
}
