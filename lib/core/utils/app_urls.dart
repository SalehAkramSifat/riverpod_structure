class AppUrls {
  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String otpVerify = '$baseUrl/auth/verify-otp';
  static const String resetPassowrd = '$baseUrl/auth/reset-password';
  static const String getMe = '$baseUrl/users/me';
}
