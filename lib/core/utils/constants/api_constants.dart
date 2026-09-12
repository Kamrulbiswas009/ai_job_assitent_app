class ApiConstants {
  static const String baseUrl = 'https://studioequip-backend.vercel.app/api/v1';

  // Auth Endpoints
  static const String register = '$baseUrl/auth/register';
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String login = '$baseUrl/auth/login';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // Subscription / Checkout Endpoints
  static const String createCheckoutSession =
      '$baseUrl/subscriptions/checkout-session';
}
