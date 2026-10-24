import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/features/onboarding/controller/onboarding_controller.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/screens/verification_screen.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';

Widget createScreen(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(428, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => GetMaterialApp(
      home: child,
      getPages: AppRoute.routes,
      builder: EasyLoading.init(),
    ),
  );
}

Finder findRichTextContaining(String pattern) {
  return find.byWidgetPredicate(
    (w) => w is RichText && w.text.toPlainText().contains(pattern),
  );
}

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  tearDown(() {
    Get.reset();
  });

  test('Countdown smoothly continues from 2 seconds to 0 seconds and stops at 0', () async {
    final controller = OnboardingController();
    controller.startResendTimer(seconds: 2);

    expect(controller.resendCountdown.value, 2);

    // After 1 second, it should be 1
    await Future.delayed(const Duration(milliseconds: 1050));
    expect(controller.resendCountdown.value, 1);

    // After another 1 second, it should reach 0
    await Future.delayed(const Duration(milliseconds: 1050));
    expect(controller.resendCountdown.value, 0);

    // After another 1 second, it stays at 0 (timer cancelled)
    await Future.delayed(const Duration(milliseconds: 1050));
    expect(controller.resendCountdown.value, 0);

    controller.onClose();
  });

  test('resumeResendTimerIfNeeded smoothly resumes countdown from 2 seconds if paused', () async {
    final controller = OnboardingController();
    // Simulate countdown paused/interrupted at 2 seconds
    controller.resendCountdown.value = 2;
    controller.resumeResendTimerIfNeeded();

    expect(controller.resendCountdown.value, 2);

    await Future.delayed(const Duration(milliseconds: 1050));
    expect(controller.resendCountdown.value, 1);

    await Future.delayed(const Duration(milliseconds: 1050));
    expect(controller.resendCountdown.value, 0);

    controller.onClose();
  });

  testWidgets('VerificationScreen counts down from 2s to 0s and enables Resend', (
    WidgetTester tester,
  ) async {
    final controller = Get.put(OnboardingController(), permanent: true);
    controller.startResendTimer(seconds: 2);

    await tester.pumpWidget(createScreen(const VerificationScreen()));
    await tester.pump();

    // At 2 seconds: shows "Resend in 2s"
    expect(findRichTextContaining('Resend in 2s'), findsOneWidget);

    // Advance 1 second -> 1s
    await tester.pump(const Duration(seconds: 1));
    expect(findRichTextContaining('Resend in 1s'), findsOneWidget);

    // Advance 1 second -> 0s -> "Didn't receive code? Resend"
    await tester.pump(const Duration(seconds: 1));
    expect(findRichTextContaining("Didn't receive code? Resend"), findsOneWidget);

    // Advance another second -> still at 0s, stable and ready to resend
    await tester.pump(const Duration(seconds: 1));
    expect(findRichTextContaining("Didn't receive code? Resend"), findsOneWidget);

    // Verify tapping Resend works when countdown reaches 0
    await tester.tap(findRichTextContaining("Didn't receive code? Resend"));
    await tester.pump();
  });
}
