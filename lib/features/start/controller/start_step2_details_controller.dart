import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/logging/logger.dart';
import '../../../../routes/app_routes.dart';
import '../model/briefing_model.dart';
import '../model/scenario_config.dart';
import '../service/briefing_service.dart';
import 'start_briefing_controller.dart';
import 'start_goals_controller.dart';

class StartStep2DetailsController extends GetxController {
  final BriefingService _briefingService = BriefingService();

  late final TextEditingController interviewKeywordsController;
  late final TextEditingController roleApplyingController;
  late final TextEditingController voiceAnswerTextController;

  // Selected goal and dynamic UI texts tailored to the scenario
  final RxString selectedGoalTitle = 'Job Interview'.obs;
  final RxString selectedScenarioSlug = 'job_interview'.obs;
  final RxString scenarioSubtitle = ''.obs;
  final RxString keywordsHint = ''.obs;
  final RxString roleFieldTitle = 'What role are you applying for?'.obs;
  final RxString roleFieldHint = 'e.g. Head of Marketing at Unilever'.obs;
  final RxString voiceQuestionTitle =
      'In your own words — why do you want this role and why are you the right person for it?'
          .obs;
  final RxString additionalNotesHint =
      'Use the text below to add a few additional sentences why you feel you are the best person to win this'
          .obs;

  // Real Audio Recorder
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  // Voice recording state
  final RxBool isRecording = false.obs;
  final RxInt recordDuration = 0.obs;
  final RxString recordedAudioPath = ''.obs;
  final RxBool isLoading = false.obs;
  Timer? _timer;

  // Briefing processing modal & API state
  final RxBool isProcessingBriefing = false.obs;
  Future<PersonalBriefingModel?>? _apiFuture;
  PersonalBriefingModel? _cachedBriefing;

  @override
  void onInit() {
    super.onInit();
    // Initially text fields are empty as requested ("intialy textfiled is null , user can text here")
    interviewKeywordsController = TextEditingController();
    roleApplyingController = TextEditingController();
    voiceAnswerTextController = TextEditingController();

    syncScenario();
  }

  /// Synchronize dynamic titles, hints and slugs based on selected scenario from Step 1
  void syncScenario({String? id, String? title}) {
    String searchKey = title ?? id ?? '';
    if (searchKey.isEmpty && Get.isRegistered<StartGoalsController>()) {
      searchKey = Get.find<StartGoalsController>().selectedGoalTitle.value;
      if (searchKey.isEmpty) {
        searchKey = Get.find<StartGoalsController>().selectedGoalId.value;
      }
    }
    if (searchKey.isEmpty) {
      searchKey = selectedGoalTitle.value;
    }

    final config = ScenarioConfig.findByTitleOrId(searchKey);
    selectedGoalTitle.value = config.title;
    selectedScenarioSlug.value = config.slug;
    scenarioSubtitle.value = config.subtitle;
    keywordsHint.value = config.keywordsHint;
    roleFieldTitle.value = config.roleTitle;
    roleFieldHint.value = config.roleHint;
    voiceQuestionTitle.value = config.voiceQuestionTitle;
    additionalNotesHint.value = config.additionalNotesHint;
  }

  @override
  void onClose() {
    interviewKeywordsController.dispose();
    roleApplyingController.dispose();
    voiceAnswerTextController.dispose();
    _timer?.cancel();
    _audioRecorder?.dispose().catchError((_) {});
    super.onClose();
  }

  // Start audio recording
  Future<void> startRecording() async {
    isRecording.value = true;
    recordDuration.value = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordDuration.value++;
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
        AppLoggerHelper.info('Started voice recording to: $filePath');
      } else {
        AppLoggerHelper.warning('Microphone permission not granted for voice recording');
      }
    } catch (e) {
      AppLoggerHelper.error('Error starting audio recording: $e', e);
    }
  }

  // Stop audio recording and return path
  Future<String?> stopRecording() async {
    if (!isRecording.value) {
      return recordedAudioPath.value.isNotEmpty ? recordedAudioPath.value : null;
    }
    isRecording.value = false;
    _timer?.cancel();
    try {
      final path = await audioRecorder.stop();
      if (path != null && path.isNotEmpty) {
        recordedAudioPath.value = path;
        AppLoggerHelper.info('Stopped voice recording. Saved at: $path');
        return path;
      }
    } catch (e) {
      AppLoggerHelper.error('Error stopping audio recording: $e', e);
    }
    return recordedAudioPath.value.isNotEmpty ? recordedAudioPath.value : null;
  }

  // Toggle audio recording
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  String _getUserFirstName() {
    final stored = StorageService.fullName?.trim();
    if (stored != null && stored.isNotEmpty) {
      return stored.split(' ').first;
    }
    if (Get.isRegistered<StartGoalsController>()) {
      final name = Get.find<StartGoalsController>().userName.value.trim();
      if (name.isNotEmpty) {
        return name.split(' ').first;
      }
    }
    return 'Aycan';
  }

  Future<void> submitDetailsAndProceed() async {
    // Automatically stop voice recording if currently active
    if (isRecording.value) {
      AppLoggerHelper.info('Continue pressed while recording. Automatically stopping voice recording...');
      await stopRecording();
    }

    final firstName = _getUserFirstName();
    final scenarioId = selectedScenarioSlug.value;

    // Use user typed text or scenario-tailored fallback
    final role = roleApplyingController.text.trim().isNotEmpty
        ? roleApplyingController.text.trim()
        : roleFieldHint.value.replaceFirst(RegExp(r'^e\.g\.\s*'), '').trim();

    final goal = interviewKeywordsController.text.trim().isNotEmpty
        ? interviewKeywordsController.text.trim()
        : (voiceAnswerTextController.text.trim().isNotEmpty
            ? voiceAnswerTextController.text.trim()
            : keywordsHint.value.trim());

    final description = voiceAnswerTextController.text.trim();
    final voicePath = recordedAudioPath.value.trim().isNotEmpty
        ? recordedAudioPath.value.trim()
        : null;

    final request = PersonalBriefingRequest(
      firstName: firstName,
      scenarioId: scenarioId,
      role: role,
      goal: goal,
      description: description,
      voiceFilePath: voicePath,
    );

    // Start background API call
    _apiFuture = _briefingService.getPersonalBriefing(request);
    _apiFuture!.then((result) {
      _cachedBriefing = result;
    });

    // Show preparation modal
    AppLoggerHelper.info(
      'Starting Personal Briefing preparation for scenario: ${selectedGoalTitle.value} (${selectedScenarioSlug.value})\n'
      'Voice File Path: ${voicePath ?? "None"}',
    );
    isProcessingBriefing.value = true;
  }

  Future<void> onProcessingComplete() async {
    try {
      // Ensure API call finishes
      if (_apiFuture != null) {
        _cachedBriefing = await _apiFuture;
      }

      final firstName = _getUserFirstName();
      final scenario = selectedGoalTitle.value;

      final briefingController = Get.find<StartBriefingController>();
      if (_cachedBriefing != null) {
        AppLoggerHelper.info(
          'Successfully received briefing from AI backend for: $scenario. Navigating to briefing.',
        );
        briefingController.setBriefingData(
          _cachedBriefing!,
          firstName: firstName,
          scenario: scenario,
        );
      } else {
        // Generate high-quality scenario tailored briefing if backend returned unsupported_scenario or is offline
        AppLoggerHelper.warning(
          'Personal Briefing API returned null or unsupported scenario. Using personalized fallback for: $scenario',
        );

        final role = roleApplyingController.text.trim().isNotEmpty
            ? roleApplyingController.text.trim()
            : roleFieldHint.value.replaceFirst(RegExp(r'^e\.g\.\s*'), '').trim();
        final goal = interviewKeywordsController.text.trim().isNotEmpty
            ? interviewKeywordsController.text.trim()
            : keywordsHint.value.trim();

        final fallbackModel = PersonalBriefingModel.createFallback(
          scenarioTitle: scenario,
          firstName: firstName,
          role: role,
          goal: goal,
        );

        briefingController.setBriefingData(
          fallbackModel,
          firstName: firstName,
          scenario: scenario,
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Error finalizing briefing data: $e', e);
    } finally {
      isProcessingBriefing.value = false;
      Get.toNamed(AppRoute.startBriefing);
    }
  }
}
