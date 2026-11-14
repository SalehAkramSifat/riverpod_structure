class AppUrls {
  AppUrls._();

  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String otpVerify = '$baseUrl/auth/verify-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  // Backward compatibility alias for any legacy reference
  static const String resetPassowrd = resetPassword;
  static const String getMe = '$baseUrl/users/me';
}
