import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studioequip_mobile_app/core/models/saved_session_model.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/features/onboarding/presentation/widgets/continue_session_dialog.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
  });

  tearDown(() async {
    await StorageService.clearSavedSession();
  });

  group('Session Resumption Logic Tests', () {
    test('SavedSessionModel encodes and decodes correctly', () {
      final session = SavedSessionModel(
        route: AppRoute.practiceSessionReady,
        title: 'Practice Session Setup',
        scenarioSlug: 'job_interview',
        assessmentId: 'test-assessment-123',
        arguments: {'key': 'value'},
        timestamp: 1234567890,
      );

      final encoded = session.encode();
      final decoded = SavedSessionModel.decode(encoded);

      expect(decoded, isNotNull);
      expect(decoded!.route, AppRoute.practiceSessionReady);
      expect(decoded.title, 'Practice Session Setup');
      expect(decoded.scenarioSlug, 'job_interview');
      expect(decoded.assessmentId, 'test-assessment-123');
      expect(decoded.arguments?['key'], 'value');
      expect(decoded.timestamp, 1234567890);
    });

    test('isResumableRoute identifies practice and start routes', () {
      expect(SavedSessionModel.isResumableRoute(AppRoute.practiceSessionReady), isTrue);
      expect(SavedSessionModel.isResumableRoute(AppRoute.practiceWarmup), isTrue);
      expect(SavedSessionModel.isResumableRoute(AppRoute.startStep5Score), isTrue);
      expect(SavedSessionModel.isResumableRoute(AppRoute.startStep2Details), isTrue);

      expect(SavedSessionModel.isResumableRoute(AppRoute.login), isFalse);
      expect(SavedSessionModel.isResumableRoute(AppRoute.registration), isFalse);
      expect(SavedSessionModel.isResumableRoute(AppRoute.splash), isFalse);
    });

    test('StorageService saves, retrieves, and preserves session across logout', () async {
      expect(StorageService.hasSavedSession(), isFalse);

      await StorageService.saveCurrentSession(
        route: AppRoute.practiceSessionReady,
        title: 'Practice Session Setup',
        scenarioSlug: 'job_interview',
        assessmentId: 'asm-999',
      );

      expect(StorageService.hasSavedSession(), isTrue);
      final retrieved = StorageService.getLastSession();
      expect(retrieved, isNotNull);
      expect(retrieved!.route, AppRoute.practiceSessionReady);
      expect(retrieved.title, 'Practice Session Setup');
      expect(retrieved.scenarioSlug, 'job_interview');
      expect(retrieved.assessmentId, 'asm-999');

      // Set user tokens
      await StorageService.saveAuthData(
        accessToken: 'fake_access',
        refreshToken: 'fake_refresh',
        userId: 'u1',
        email: 'test@example.com',
      );
      expect(StorageService.hasToken(), isTrue);

      // Perform logout (preserves saved session by default)
      await StorageService.logoutUser();
      expect(StorageService.hasToken(), isFalse);
      expect(StorageService.hasSavedSession(), isTrue);

      // Clear saved session explicitly
      await StorageService.clearSavedSession();
      expect(StorageService.hasSavedSession(), isFalse);
    });
  });

  group('ContinueSessionDialog Widget Tests', () {
    testWidgets('ContinueSessionDialog renders title, session info and buttons', (tester) async {
      tester.view.physicalSize = const Size(428 * 2, 926 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final session = SavedSessionModel(
        route: AppRoute.practiceSessionReady,
        title: 'Practice Session Setup',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(428, 932),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: ContinueSessionDialog(session: session),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Continue Previous Session?'), findsOneWidget);
      expect(find.text('Practice Session Setup'), findsOneWidget);
      expect(find.text('Yes, Continue Session'), findsOneWidget);
      expect(find.text('No, Start Fresh'), findsOneWidget);
    });

    testWidgets('Tapping Yes, Continue Session pops with true', (tester) async {
      tester.view.physicalSize = const Size(428 * 2, 926 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final session = SavedSessionModel(
        route: AppRoute.practiceSessionReady,
        title: 'Practice Session Setup',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      bool? result;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(428, 932),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await ContinueSessionDialog.show(
                      context,
                      session: session,
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Yes, Continue Session'), findsOneWidget);

      // Tap Yes
      await tester.tap(find.text('Yes, Continue Session'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('Tapping No, Start Fresh pops with false', (tester) async {
      tester.view.physicalSize = const Size(428 * 2, 926 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final session = SavedSessionModel(
        route: AppRoute.startStep5Score,
        title: 'Influence Score',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      bool? result;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(428, 932),
          builder: (_, _) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () async {
                    result = await ContinueSessionDialog.show(
                      context,
                      session: session,
                    );
                  },
                  child: const Text('Open Dialog'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('No, Start Fresh'), findsOneWidget);

      // Tap No
      await tester.tap(find.text('No, Start Fresh'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });
  });
}
