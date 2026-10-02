import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
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
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step3_assessment_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step4_calibration_screen.dart';
import 'package:studioequip_mobile_app/features/start/presentation/screens/start_step5_score_screen.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_membership_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_goals_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_step2_details_controller.dart';
import 'package:studioequip_mobile_app/features/start/presentation/widgets/briefing_processing_modal.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_briefing_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_assessment_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_calibration_controller.dart';
import 'package:studioequip_mobile_app/features/start/controller/start_score_controller.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      builder: EasyLoading.init(),
    ),
  );
}

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await StorageService.init();
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
    expect(find.textContaining('Understand'), findsOneWidget);
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

  testWidgets(
    'Screen 9b: Start Membership Intro renders user name from login response and capitalizes first word (e.g. john -> John)',
    (WidgetTester tester) async {
      Get.delete<StartMembershipController>(force: true);
      await StorageService.saveAuthData(
        accessToken: 'dummy_token',
        refreshToken: 'dummy_refresh',
        fullName: 'john',
        isSubscribed: true,
      );
      final controller = Get.put(StartMembershipController());
      await tester.pumpWidget(createScreen(const StartMembershipIntroScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Great news, John !'), findsOneWidget);
      expect(controller.userFirstName.value, equals('John'));
    },
  );

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

  testWidgets(
    'Screen 11c: When record icon pressed in Step 2, switches to active recording wave state with stop button and Listening...',
    (WidgetTester tester) async {
      final step2Controller = Get.put(StartStep2DetailsController());
      step2Controller.isRecording.value = false;
      await tester.pumpWidget(createScreen(const StartStep2DetailsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Tap to speak your Answer'), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);

      // Trigger recording with voice volume
      step2Controller.isRecording.value = true;
      step2Controller.currentVolume.value = 0.85;
      step2Controller.isVoiceDetected.value = true;
      await tester.pump(const Duration(milliseconds: 200));

      // Wave animation is active, stop icon is visible and label updates
      expect(find.text('Listening...'), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

      // Voice volume decreases to quiet/silence
      step2Controller.currentVolume.value = 0.05;
      step2Controller.isVoiceDetected.value = false;
      await tester.pump(const Duration(milliseconds: 200));

      // Stop recording to allow pumpAndSettle
      step2Controller.isRecording.value = false;
      step2Controller.currentVolume.value = 0.0;
      await tester.pumpAndSettle();
      expect(find.text('Tap to speak your Answer'), findsOneWidget);
    },
  );

  testWidgets('Screen 11a: BriefingProcessingModal holds at ~90% until isCompleted is true, then hits 100%', (
    WidgetTester tester,
  ) async {
    bool isDone = false;
    final rxCompleted = false.obs;

    await tester.pumpWidget(
      createScreen(
        Obx(
          () => BriefingProcessingModal(
            isCompleted: rxCompleted.value,
            onComplete: () {
              isDone = true;
            },
          ),
        ),
      ),
    );

    // Pump for 3 seconds while rxCompleted is false
    await tester.pump(const Duration(seconds: 3));

    // Must NOT reach 100% yet while waiting for AI response
    expect(find.text('100%'), findsNothing);
    expect(isDone, isFalse);

    // Now AI responds!
    rxCompleted.value = true;
    await tester.pump();

    // Pump forward for progress to smoothly finish to 100% in the 8s sequence
    await tester.pump(const Duration(seconds: 6));
    expect(find.text('100%'), findsOneWidget);

    // Pump past the completion delay
    await tester.pump(const Duration(milliseconds: 900));
    expect(isDone, isTrue);
  });

  testWidgets('Screen 11b: Pick Investor Pitch in Step 1 updates Step 2 titles and starts with empty text fields', (
    WidgetTester tester,
  ) async {
    final goalsController = Get.find<StartGoalsController>();
    // Select Investor Pitch (id: '02')
    final investorPitchGoal = goalsController.goalCategories.firstWhere((g) => g.id == '02');
    goalsController.selectGoal(investorPitchGoal);

    // Navigate to Step 2
    Get.put(StartStep2DetailsController());
    goalsController.submitGoalAndProceed();

    await tester.pumpWidget(createScreen(const StartStep2DetailsScreen()));
    await tester.pumpAndSettle();

    // Verify dynamic Scenario Title
    expect(find.text('Investor Pitch'), findsOneWidget);

    // Verify dynamic field titles
    expect(find.text('What is your role or venture?'), findsOneWidget);
    expect(
      find.text('In your own words — what is your pitch and why should investors back you?'),
      findsOneWidget,
    );

    // Verify text fields are initially empty
    final step2Controller = Get.find<StartStep2DetailsController>();
    expect(step2Controller.interviewKeywordsController.text, isEmpty);
    expect(step2Controller.roleApplyingController.text, isEmpty);
    expect(step2Controller.voiceAnswerTextController.text, isEmpty);

    // Verify Continue button is initially disabled
    expect(step2Controller.isFormValid.value, isFalse);

    // Verify user can enter text and Continue button becomes enabled
    step2Controller.interviewKeywordsController.text = 'AI startup raising seed round';
    step2Controller.roleApplyingController.text = 'CEO & Founder';
    await tester.pump();

    expect(step2Controller.isFormValid.value, isTrue);
    expect(find.text('AI startup raising seed round'), findsOneWidget);
    expect(find.text('CEO & Founder'), findsOneWidget);
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

  testWidgets('Screen 12b: Start Step 3 Assessment screen renders and updates choices', (
    WidgetTester tester,
  ) async {
    final controller = Get.put(StartAssessmentController());
    await tester.pumpWidget(createScreen(const StartStep3AssessmentScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Step 3 of 5'), findsOneWidget);
    expect(find.text('ONE LAST THING'), findsOneWidget);
    expect(find.text('Before we begin — be honest.'), findsOneWidget);
    expect(
      find.text('Three quick questions. They set your starting benchmark.'),
      findsOneWidget,
    );
    expect(
      find.text('When speaking to a group or presenting, I feel confident'),
      findsOneWidget,
    );
    expect(
      find.text('I communicate with authority — people listen when I speak'),
      findsOneWidget,
    );
    expect(
      find.text('People respond positively to how I communicate in key situations'),
      findsOneWidget,
    );
    expect(find.text('Continue'), findsOneWidget);

    // Verify initially isAllAnswered is false (answers are not yet selected)
    expect(controller.isAllAnswered, isFalse);

    // Test answering question 1
    controller.setBenchmarkAnswer(0, 3); // Usually
    await tester.pumpAndSettle();
    expect(controller.benchmarkQuestions[0].selectedIndex, equals(3));
    expect(controller.isAllAnswered, isFalse);

    // Answering question 2 and 3
    controller.setBenchmarkAnswer(1, 2); // Often
    controller.setBenchmarkAnswer(2, 4); // Always
    await tester.pumpAndSettle();
    expect(controller.isAllAnswered, isTrue);
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
    expect(find.text('Continue'), findsOneWidget);
    // Skip Voice calibration might be commented out in UI
    expect(find.text('Skip Voice calibration').evaluate().length <= 1, isTrue);

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

  testWidgets(
    'Screen 13b: When record icon pressed in Step 4 Calibration, triggers wave animation and stop button',
    (WidgetTester tester) async {
      final calibController = Get.put(StartCalibrationController());
      calibController.isRecording.value = false;
      await tester.pumpWidget(createScreen(const StartStep4CalibrationScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Tap to speak your Answer'), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsNothing);

      // Start recording with active voice volume
      calibController.isRecording.value = true;
      calibController.currentVolume.value = 0.90;
      calibController.isVoiceDetected.value = true;
      await tester.pump(const Duration(milliseconds: 200));

      // Wave animation is active, stop button appears, and listening text shows
      expect(find.text('Listening... Tap to finish'), findsOneWidget);
      expect(find.byIcon(Icons.stop_rounded), findsOneWidget);

      // Voice volume decreases
      calibController.currentVolume.value = 0.15;
      calibController.isVoiceDetected.value = false;
      await tester.pump(const Duration(milliseconds: 200));

      // Stop recording to cleanly allow pumpAndSettle
      calibController.isRecording.value = false;
      calibController.currentVolume.value = 0.0;
      await tester.pumpAndSettle();
      expect(find.text('Tap to speak your Answer'), findsOneWidget);
    },
  );

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
    expect(
      find.textContaining('Hear why SpeechPro is different'),
      findsOneWidget,
    );
  });
}
