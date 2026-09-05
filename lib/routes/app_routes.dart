import 'package:get/get.dart';

import '../features/onboarding/screens/about_speech_pro_screen1.dart';
import '../features/onboarding/screens/about_speech_pro_screen2.dart';
import '../features/onboarding/screens/about_speech_pro_screen3.dart';
import '../features/onboarding/screens/checkout_screen.dart';
import '../features/onboarding/screens/forgot_password_screen.dart';
import '../features/onboarding/screens/membership_screen.dart';
import '../features/onboarding/screens/onboarding_login_screen.dart';
import '../features/onboarding/screens/registration_screen.dart';
import '../features/onboarding/screens/reset_password_screen.dart';
import '../features/onboarding/screens/reset_password_verification_screen.dart';
import '../features/onboarding/screens/splash_get_started_screen.dart';
import '../features/onboarding/screens/splash_logo_screen.dart';
import '../features/onboarding/screens/uses_of_ai_screen.dart';
import '../features/onboarding/screens/verification_screen.dart';

class AppRoute {
  static const String splash = '/';
  static const String splashGetStarted = SplashGetStartedScreen.routeName;
  static const String registration = RegistrationScreen.routeName;
  static const String verification = VerificationScreen.routeName;
  static const String login = OnboardingLoginScreen.routeName;
  static const String forgotPassword = ForgotPasswordScreen.routeName;
  static const String resetPasswordVerification =
      ResetPasswordVerificationScreen.routeName;
  static const String resetPassword = ResetPasswordScreen.routeName;
  static const String about1 = AboutSpeechProScreen1.routeName;
  static const String about2 = AboutSpeechProScreen2.routeName;
  static const String about3 = AboutSpeechProScreen3.routeName;
  static const String membership = MembershipScreen.routeName;
  static const String checkout = CheckoutScreen.routeName;
  static const String usesOfAi = UsesOfAiScreen.routeName;

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
  ];
}
