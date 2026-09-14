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

import 'package:studioequip_mobile_app/features/onboarding/controller/onboarding_controller.dart';

Widget createScreen(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(428, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => GetMaterialApp(
      home: child,
    ),
  );
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(OnboardingController());
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
}
