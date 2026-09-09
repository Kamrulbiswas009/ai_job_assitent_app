import 'package:get/get.dart';

import '../features/onboarding/presentation/screens/about_speech_pro_screen1.dart';
import '../features/onboarding/presentation/screens/about_speech_pro_screen2.dart';
import '../features/onboarding/presentation/screens/about_speech_pro_screen3.dart';
import '../features/onboarding/presentation/screens/checkout_screen.dart';
import '../features/onboarding/presentation/screens/forgot_password_screen.dart';
import '../features/onboarding/presentation/screens/membership_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_login_screen.dart';
import '../features/onboarding/presentation/screens/registration_screen.dart';
import '../features/onboarding/presentation/screens/reset_password_screen.dart';
import '../features/onboarding/presentation/screens/reset_password_verification_screen.dart';
import '../features/onboarding/presentation/screens/splash_get_started_screen.dart';
import '../features/onboarding/presentation/screens/splash_logo_screen.dart';
import '../features/onboarding/presentation/screens/uses_of_ai_screen.dart';
import '../features/onboarding/presentation/screens/verification_screen.dart';
import '../features/start/presentation/screens/start_briefing_screen.dart';
import '../features/start/presentation/screens/start_membership_intro_screen.dart';
import '../features/start/presentation/screens/start_step1_goals_screen.dart';
import '../features/start/presentation/screens/start_step2_details_screen.dart';
import '../features/start/presentation/screens/start_step3_assessment_screen.dart';
import '../features/start/presentation/screens/start_step4_calibration_screen.dart';
import '../features/start/presentation/screens/start_step5_score_screen.dart';

class AppRoute {
  static const String splash = '/';
  static const String splashGetStarted = '/splash-get-started';
  static const String registration = '/registration';
  static const String verification = '/verification';
  static const String login = '/onboarding-login';
  static const String forgotPassword = '/forgot-password';
  static const String resetPasswordVerification = '/reset-password-verification';
  static const String resetPassword = '/reset-password';
  static const String about1 = '/about-speech-pro-1';
  static const String about2 = '/about-speech-pro-2';
  static const String about3 = '/about-speech-pro-3';
  static const String membership = '/membership';
  static const String checkout = '/checkout';
  static const String usesOfAi = '/uses-of-ai';
  static const String startMembershipIntro = '/start-membership-intro';
  static const String startStep1Goals = '/start-step1-goals';
  static const String startStep2Details = '/start-step2-details';
  static const String startBriefing = '/start-briefing';
  static const String startStep3Assessment = '/start-step3-assessment';
  static const String startStep4Calibration = '/start-step4-calibration';
  static const String startStep5Score = '/start-step5-score';

  static String getLoginScreen() => login;

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => const SplashLogoScreen()),
    GetPage(
      name: splashGetStarted,
      page: () => const SplashGetStartedScreen(),
    ),
    GetPage(name: registration, page: () => const RegistrationScreen()),
    GetPage(name: verification, page: () => const VerificationScreen()),
    GetPage(name: login, page: () => const OnboardingLoginScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
      name: resetPasswordVerification,
      page: () => const ResetPasswordVerificationScreen(),
    ),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen()),
    GetPage(name: about1, page: () => const AboutSpeechProScreen1()),
    GetPage(name: about2, page: () => const AboutSpeechProScreen2()),
    GetPage(name: about3, page: () => const AboutSpeechProScreen3()),
    GetPage(name: membership, page: () => const MembershipScreen()),
    GetPage(name: checkout, page: () => const CheckoutScreen()),
    GetPage(name: usesOfAi, page: () => const UsesOfAiScreen()),
    GetPage(
      name: startMembershipIntro,
      page: () => const StartMembershipIntroScreen(),
    ),
    GetPage(
      name: startStep1Goals,
      page: () => const StartStep1GoalsScreen(),
    ),
    GetPage(
      name: startStep2Details,
      page: () => const StartStep2DetailsScreen(),
    ),
    GetPage(
      name: startBriefing,
      page: () => const StartBriefingScreen(),
    ),
    GetPage(
      name: startStep3Assessment,
      page: () => const StartStep3AssessmentScreen(),
    ),
    GetPage(
      name: startStep4Calibration,
      page: () => const StartStep4CalibrationScreen(),
    ),
    GetPage(
      name: startStep5Score,
      page: () => const StartStep5ScoreScreen(),
    ),
  ];
}
