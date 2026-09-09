import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/forgot_password_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/onboarding_login_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/registration_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/reset_password_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/reset_password_verification_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/splash_get_started_screen.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/verification_screen.dart';

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
  testWidgets('Screen 0: Welcome / Get Started screen renders perfectly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createScreen(const SplashGetStartedScreen()));
    await tester.pumpAndSettle();
    expect(find.text('welcome to'), findsOneWidget);
    expect(find.text('Power through speech'), findsOneWidget);
    expect(find.text('Influence through impact'), findsOneWidget);
    expect(find.text('Authority through presence'), findsOneWidget);
    expect(find.text('Create account →'), findsOneWidget);
    expect(find.text('Already have an account? Sign in'), findsOneWidget);
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
}
