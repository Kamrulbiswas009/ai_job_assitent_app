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

  // Coaching / Briefing Endpoints
  static const String personalBriefing =
      'https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/coaching/personal-briefing';

  // Assessment Endpoints
  static const String selfAssessment =
      'https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/self-assessment';

  static String assessmentVoice(String assessmentId) =>
      'https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/$assessmentId/voice';

  static String assessmentResult(String assessmentId) =>
      'https://rosendo-vitiable-sari.ngrok-free.dev/api/v1/assessment/$assessmentId/result';
}
