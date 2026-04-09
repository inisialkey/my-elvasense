class ListAPI {
  ListAPI._(); // coverage:ignore-line

  /// Auth
  static const String user = '/v1/api/user';
  static const String login = '/api/v1/sign-in';
  static const String logout = '/api/v1/user/logout';
  static const String refreshToken = '/api/v1/refresh-token';

  /// User
  static const String users = '/v1/api/user/all';
}
