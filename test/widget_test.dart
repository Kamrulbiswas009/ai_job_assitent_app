import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/forgot_password_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/onboarding_login_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/membership_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/registration_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/reset_password_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/reset_password_verification_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/splash_get_started_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/uses_of_ai_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/verification_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_membership_intro_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step1_goals_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step2_details_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_briefing_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step4_calibration_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step5_score_screen.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_membership_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_goals_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_step2_details_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_briefing_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_calibration_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_score_controller.dart';

import 'package:studioequip_mobile_app/features/onboarding/controller/onboarding_controller.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';

Widget createScreen(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(428, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => GetMaterialApp(
      home: child,
      getPages: AppRoute.routes,
    ),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(OnboardingController());
    Get.put(StartMembershipController());
    Get.put(StartGoalsController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Screen 0: Welcome / Get Started screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const SplashGetStartedScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Welcome to'), findsOneWidget);
    expect(find.text('Power Through Speech'), findsOneWidget);
    expect(find.text('Influence Through Impact'), findsOneWidget);
    expect(find.text('Authority Through Presence'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Screen 1: Registration screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const RegistrationScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });

  testWidgets('Screen 2: Verification screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const VerificationScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Check your email'), findsOneWidget);
    expect(find.text('Verify email'), findsOneWidget);
  });

  testWidgets('Screen 3: Login screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const OnboardingLoginScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
  });

  testWidgets('Screen 4: Forgot Password screen (Image 2) renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const ForgotPasswordScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Forgot Password !'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
  });

  testWidgets('Screen 5: Reset Password Verification screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      createScreen(const ResetPasswordVerificationScreen()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Verification code'), findsOneWidget);
    expect(find.text('Verify email'), findsOneWidget);
  });

  testWidgets('Screen 6: Reset Password screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const ResetPasswordScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Reset Password'), findsWidgets);
    expect(find.text('New Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });

  testWidgets('Screen 7: Membership screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const MembershipScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Your Membership'), findsOneWidget);
    expect(find.text('Start training today.'), findsOneWidget);
    expect(find.text('Full access to SpeechPro. Cancel anytime.'), findsOneWidget);
    expect(find.text('SpeechPro training for every high-stakes conversation'), findsOneWidget);
  });

  testWidgets('Screen 8: Uses of AI screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const UsesOfAiScreen()));
    await tester.pumpAndSettle();
    expect(find.text('How SpeechPro uses AI'), findsOneWidget);
    expect(find.text('Anthropic Claude'), findsOneWidget);
    expect(find.text('Deepgram Nova-3'), findsOneWidget);
    expect(find.text('OpenAI Whisper'), findsOneWidget);
    expect(find.text('ElevenLabs'), findsOneWidget);
    expect(find.text('I Understand,Continue'), findsOneWidget);
    expect(find.text('Not Now'), findsOneWidget);
  });

  testWidgets('Screen 9: Start Membership Intro screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const StartMembershipIntroScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Great news, Aycan !'), findsOneWidget);
    expect(find.textContaining('membership has started'), findsOneWidget);
    expect(find.text('Power Through Speech'), findsOneWidget);
    expect(find.text('Influence Through Impact'), findsOneWidget);
    expect(find.text('Authority Through Presence'), findsOneWidget);
    expect(find.text('What do you want to achieve'), findsOneWidget);
  });

  testWidgets('Screen 10: Start Step 1 Goals screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const StartStep1GoalsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Step 1 of 5'), findsOneWidget);
    expect(find.text('What do you want to achieve?'), findsOneWidget);
    expect(find.text('Job Interview'), findsOneWidget);
    expect(find.text('Investor Pitch'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Screen 11: Start Step 2 Details screen and modal transition flow', (
    WidgetTester tester,
  ) async {
    Get.put(StartStep2DetailsController());
    await tester.pumpWidget(createScreen(const StartStep2DetailsScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Step 2 of 5'), findsOneWidget);
    expect(find.text('Job Interview'), findsOneWidget);
    expect(find.text('What role are you applying for?'), findsOneWidget);
    expect(
      find.text('In your own words — why do you want this role and why are you the right person for it?'),
      findsOneWidget,
    );
    expect(find.text('Recording · 0:00'), findsOneWidget);
    expect(find.text('Tap to speak your Answer'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // Trigger submitDetailsAndProceed to show the black processing modal transition
    final step2Controller = Get.find<StartStep2DetailsController>();
    step2Controller.submitDetailsAndProceed();
    await tester.pump();

    // Verify Black Processing Modal without score and with 3 sequential steps
    expect(find.text('Preparing your briefing...'), findsOneWidget);
    expect(find.text('Almost ready'), findsOneWidget);
    expect(find.text('Absorbing what you have shared'), findsOneWidget);
    expect(find.text('Structuring our response'), findsOneWidget);
    expect(find.text('Delivering your briefing'), findsOneWidget);

    step2Controller.isProcessingBriefing.value = false;
    await tester.pumpAndSettle();
  });

  testWidgets('Screen 12: Start Briefing screen renders perfectly', (
    WidgetTester tester,
  ) async {
    Get.put(StartBriefingController());
    await tester.pumpWidget(createScreen(const StartBriefingScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsWidgets);
    expect(find.text('Job Interview'), findsWidgets);
    expect(find.textContaining('Aycan, your personal'), findsWidgets);
    expect(find.text('What we heard'), findsOneWidget);
    expect(find.text('Put It Into Practice'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Screen 13: Start Step 4 Calibration and Score Calculation Modal', (
    WidgetTester tester,
  ) async {
    Get.put(StartCalibrationController());
    await tester.pumpWidget(createScreen(const StartStep4CalibrationScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Step 4 of 5'), findsOneWidget);
    expect(find.text('VOICE CALIBRATION'), findsOneWidget);
    expect(find.textContaining('Now I want to'), findsOneWidget);
    expect(find.text('Skip Voice calibration'), findsOneWidget);

    // Trigger score calculation modal
    final calibController = Get.find<StartCalibrationController>();
    calibController.proceedToStep5();
    await tester.pump();

    // Verify Score Calculation Modal (Screen 2 in Figma)
    expect(find.text('Calculating your score ...'), findsOneWidget);
    expect(find.text('Almost ready'), findsOneWidget);
    expect(find.text('Calculation step'), findsOneWidget);
    expect(find.text('Analyzing your voice'), findsOneWidget);
    expect(find.text('Measuring your delivery'), findsOneWidget);
    expect(find.text('Comparing with your self assessment'), findsOneWidget);
    expect(find.text('Calculating your Influence Score'), findsOneWidget);

    calibController.isCalculating.value = false;
    await tester.pumpAndSettle();
  });

  testWidgets('Screen 14: Start Step 5 Score screen with Dimension Breakdown renders perfectly', (
    WidgetTester tester,
  ) async {
    Get.put(StartScoreController());
    await tester.pumpWidget(createScreen(const StartStep5ScoreScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Step 5 of 5'), findsOneWidget);
    expect(find.text('Your Starting Influence Score'), findsOneWidget);
    expect(find.text('59'), findsNWidgets(2));
    expect(find.text('/100'), findsOneWidget);
    expect(find.text('Developing'), findsOneWidget);
    expect(find.text('Dimension Breakdown'), findsOneWidget);
    expect(find.text('Confidence'), findsOneWidget);
    expect(find.text('Presence'), findsOneWidget);
    expect(find.text('Authority'), findsOneWidget);
    expect(find.text('Leadership'), findsOneWidget);
    expect(find.text('Persuasion'), findsOneWidget);
    expect(find.text('Communication'), findsOneWidget);
    expect(find.text('There is real instinct here.'), findsOneWidget);
    expect(find.text('YOUR TRAINING PATH'), findsOneWidget);
    expect(find.text('Start My First Session'), findsOneWidget);
    expect(find.text('Hear why SpeechPro is different'), findsOneWidget);
  });
}
