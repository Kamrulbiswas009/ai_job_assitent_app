class ApiConstants {
  static const String baseUrl = 'https://studioequip-backend.vercel.app/api/v1';
  // Auth Endpoints
  static const String register = '$baseUrl/auth/register';
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String refreshToken = '$baseUrl/auth/refresh-token';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // Stripe
  static const String stripePublishableKey =
      'pk_test_51UE3RGP6NOcdSbkq0Cz8omsVHWnYrSHDLJJeekU1yZouNkAVk7Rpyku8AzzalgA2wEAHTpq5WHfeNVjRDBJwpkVJ00oNP2E6k7';

  // Subscription / Checkout Endpoints
  static const String createCheckoutSession =
      '$baseUrl/subscriptions/checkout-session';

  // AI Backend Base URL
  static const String aiBaseUrl =
      'https://ai.speechpro.uk/api/v1';
  static const String aiApiBaseUrl = 'https://ai.speechpro.uk/api/ai';

  // Coaching / Briefing Endpoints
  static const String personalBriefing =
      '$aiBaseUrl/coaching/personal-briefing';
  static const String aiSessionBrief = '$aiApiBaseUrl/session-brief';

  // Assessment Endpoints
  static const String selfAssessment = '$aiBaseUrl/assessment/self-assessment';

  static String assessmentVoice(String assessmentId) =>
      '$aiBaseUrl/assessment/$assessmentId/voice';

  static String assessmentResult(String assessmentId) =>
      '$aiBaseUrl/assessment/$assessmentId/result';

  // Practice / Session Endpoints
  static String sessionPrepare(String scenarioSlug) =>
      '$baseUrl/sessions/prepare?scenarioSlug=$scenarioSlug';

  static const String sessionStart = '$baseUrl/sessions/start';

  static String sessionQuestions(String sessionId) =>
      '$baseUrl/sessions/$sessionId/questions';

  static const String evaluateAnswer = '$aiApiBaseUrl/evaluate-answer';
}
