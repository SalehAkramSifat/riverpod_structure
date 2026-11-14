class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String otpVerify = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';

  // User endpoints
  static const String getMe = '/users/me';
}
