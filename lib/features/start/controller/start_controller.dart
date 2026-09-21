import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../routes/app_routes.dart';
import '../model/start_models.dart';

class StartController extends GetxController {
  final RxString userName = 'Aycan Doganlar'.obs;
  final RxString userFirstName = 'Aycan'.obs;

  // Real Audio Recorder instance (lazy)
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  // Step 1: Goals
  final RxString selectedGoalId = '01'.obs;
  final RxString selectedGoalTitle = 'Job Interview'.obs;

  final List<GoalCategoryModel> goalCategories = [
    GoalCategoryModel(id: '01', number: '01', title: 'Job Interview'),
    GoalCategoryModel(id: '02', number: '02', title: 'Investor Pitch'),
    GoalCategoryModel(id: '03', number: '03', title: 'Promotion or Pay Rise'),
    GoalCategoryModel(id: '04', number: '04', title: 'TED Talk or Presentation'),
    GoalCategoryModel(id: '05', number: '05', title: 'Sales or Client Meeting'),
    GoalCategoryModel(id: '06', number: '06', title: 'Podcast or Convets'),
    GoalCategoryModel(id: '07', number: '07', title: 'Social Confidence'),
    GoalCategoryModel(id: '08', number: '08', title: 'English and Pronunciation'),
    GoalCategoryModel(id: '09', number: '09', title: 'Difficult Conversation'),
    GoalCategoryModel(id: '10', number: '10', title: 'Negotiation'),
    GoalCategoryModel(id: '11', number: '11', title: 'Leading a Team'),
    GoalCategoryModel(id: '12', number: '12', title: 'Board or Executive Meeting'),
    GoalCategoryModel(id: '13', number: '13', title: 'TV, Radio or Press'),
    GoalCategoryModel(id: '14', number: '14', title: 'Wedding Speech or Toast'),
    GoalCategoryModel(id: '15', number: '15', title: 'Training or Teaching'),
    GoalCategoryModel(id: '16', number: '16', title: 'Virtual and Zoom Presence'),
    GoalCategoryModel(id: '17', number: '17', title: 'Overcoming Speaking Anxiety'),
    GoalCategoryModel(id: '18', number: '18', title: 'Something Else'),
  ];

  // Step 2: Goal Details
  late final TextEditingController interviewKeywordsController;
  late final TextEditingController roleApplyingController;
  late final TextEditingController voiceAnswerTextController;

  // Step 2: Voice recording
  final RxBool isStep2Recording = false.obs;
  final RxInt step2RecordDuration = 0.obs;
  final RxString step2RecordedAudioPath = ''.obs;
  Timer? _step2Timer;

  // Briefing Loading State
  final RxInt briefingLoadingStage = 0.obs; // 0, 1, 2, 3 (Done)
  final RxBool isBriefingReady = false.obs;

  // Step 3: Assessment
  final RxList<BenchmarkQuestionModel> benchmarkQuestions =
      <BenchmarkQuestionModel>[
    BenchmarkQuestionModel(
      id: 'q1',
      title: 'When speaking to a group or presenting, I feel confident',
      selectedIndex: 1, // Sometimes
    ),
    BenchmarkQuestionModel(
      id: 'q2',
      title: 'I communicate with authority — people listen when I speak',
      selectedIndex: 0, // Rarely
    ),
    BenchmarkQuestionModel(
      id: 'q3',
      title: 'People respond positively to how I communicate in key situations',
      selectedIndex: 0, // Rarely
    ),
  ].obs;

  // Step 4: Voice Calibration
  final RxBool isCalibrationRecording = false.obs;
  final RxInt calibrationDuration = 0.obs;
  final RxString calibrationRecordedAudioPath = ''.obs;
  Timer? _calibrationTimer;

  // Step 5: Score
  final RxInt startingInfluenceScore = 59.obs;

  @override
  void onInit() {
    super.onInit();
    interviewKeywordsController = TextEditingController(
      text:
          'I have a job interview coming up and I want to walk in with complete authority and conviction.',
    );
    roleApplyingController = TextEditingController();
    voiceAnswerTextController = TextEditingController();
  }

  @override
  void onClose() {
    interviewKeywordsController.dispose();
    roleApplyingController.dispose();
    voiceAnswerTextController.dispose();
    _step2Timer?.cancel();
    _calibrationTimer?.cancel();
    _audioRecorder?.dispose();
    super.onClose();
  }

  void selectGoal(GoalCategoryModel goal) {
    selectedGoalId.value = goal.id;
    selectedGoalTitle.value = goal.title;
  }

  // Real Voice recording toggle for Step 2
  Future<void> toggleStep2Recording() async {
    if (isStep2Recording.value) {
      isStep2Recording.value = false;
      _step2Timer?.cancel();
      try {
        final path = await audioRecorder.stop();
        if (path != null) {
          step2RecordedAudioPath.value = path;
        }
      } catch (_) {
        // Native recorder not yet linked, timer stopped gracefully
      }
    } else {
      isStep2Recording.value = true;
      step2RecordDuration.value = 0;
      _step2Timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        step2RecordDuration.value++;
      });

      try {
        if (await audioRecorder.hasPermission()) {
          final dir = await getApplicationDocumentsDirectory();
          final filePath =
              '${dir.path}/step2_voice_answer_${DateTime.now().millisecondsSinceEpoch}.m4a';

          await audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: filePath,
          );
        }
      } catch (e) {
        // Native plugin requires app restart to link; visual recording timer continues smoothly
        debugPrint('Voice record native status: $e');
      }
    }
  }

  // Real Voice recording toggle for Calibration (Step 4)
  Future<void> toggleCalibrationRecording() async {
    if (isCalibrationRecording.value) {
      isCalibrationRecording.value = false;
      _calibrationTimer?.cancel();
      try {
        final path = await audioRecorder.stop();
        if (path != null) {
          calibrationRecordedAudioPath.value = path;
        }
      } catch (_) {
        // Native recorder not yet linked, timer stopped gracefully
      }
    } else {
      isCalibrationRecording.value = true;
      calibrationDuration.value = 0;
      _calibrationTimer =
          Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (calibrationDuration.value >= 60) {
          await toggleCalibrationRecording();
        } else {
          calibrationDuration.value++;
        }
      });

      try {
        if (await audioRecorder.hasPermission()) {
          final dir = await getApplicationDocumentsDirectory();
          final filePath =
              '${dir.path}/calibration_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

          await audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: filePath,
          );
        }
      } catch (e) {
        // Native plugin requires app restart to link; visual calibration timer continues smoothly
        debugPrint('Voice calibration native status: $e');
      }
    }
  }

  void setBenchmarkAnswer(int questionIndex, int optionIndex) {
    benchmarkQuestions[questionIndex].selectedIndex = optionIndex;
    benchmarkQuestions.refresh();
  }

  // Briefing animation simulation
  void startBriefingGeneration() {
    isBriefingReady.value = false;
    briefingLoadingStage.value = 0;

    Future.delayed(const Duration(milliseconds: 900), () {
      briefingLoadingStage.value = 1;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      briefingLoadingStage.value = 2;
    });

    Future.delayed(const Duration(milliseconds: 2600), () {
      briefingLoadingStage.value = 3;
      isBriefingReady.value = true;
    });
  }

  // Formatting helpers
  String formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Navigation methods
  void goToStep1() {
    Get.toNamed(AppRoute.startStep1Goals);
  }

  void goToStep2() {
    Get.toNamed(AppRoute.startStep2Details);
  }

  void goToBriefing() {
    startBriefingGeneration();
    Get.toNamed(AppRoute.startBriefing);
  }

  void goToStep3() {
    Get.toNamed(AppRoute.startStep3Assessment);
  }

  void goToStep4() {
    Get.toNamed(AppRoute.startStep4Calibration);
  }

  void goToStep5() {
    Get.toNamed(AppRoute.startStep5Score);
  }

  void finishStartFlow() {
    try {
      EasyLoading.showSuccess('Your training session is starting!')
          .catchError((_) {});
    } catch (_) {}
  }
}
