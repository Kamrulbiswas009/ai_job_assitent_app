import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final BriefingService _briefingService;

  StartStep2DetailsController({BriefingService? briefingService})
    : _briefingService = briefingService ?? BriefingService();

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
  final RxDouble currentVolume =
      0.0.obs; // 0.0 to 1.0 real-time microphone volume
  final RxBool isVoiceDetected = false.obs;
  Timer? _timer;
  Timer? _amplitudeTimer;

  // Briefing processing modal & API state
  final RxBool isProcessingBriefing = false.obs;
  final RxBool isAiResponseReceived = false.obs;
  Future<PersonalBriefingModel?>? _apiFuture;
  Future<PersonalBriefingModel?>? get apiFuture => _apiFuture;
  PersonalBriefingModel? _cachedBriefing;

  // Form validation state (enabled when user fills the required data)
  final RxBool isFormValid = false.obs;

  void _checkFormValidation() {
    final hasGoal = interviewKeywordsController.text.trim().isNotEmpty;
    final hasRole = roleApplyingController.text.trim().isNotEmpty;
    isFormValid.value = hasGoal && hasRole;
  }

  void _showSafeSnackbar(
    String title,
    String message, {
    int durationSeconds = 3,
    Widget? mainButton,
  }) {
    if (Get.context != null) {
      try {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2C2C2E),
          colorText: Colors.white,
          duration: Duration(seconds: durationSeconds),
          margin: const EdgeInsets.all(16),
          mainButton: mainButton as TextButton?,
        );
        return;
      } catch (_) {}
    }
    try {
      EasyLoading.showInfo(message).catchError((_) {});
    } catch (_) {}
  }

  @override
  void onInit() {
    super.onInit();
    // Initially text fields are empty as requested
    interviewKeywordsController = TextEditingController();
    roleApplyingController = TextEditingController();
    voiceAnswerTextController = TextEditingController();

    interviewKeywordsController.addListener(_checkFormValidation);
    roleApplyingController.addListener(_checkFormValidation);
    voiceAnswerTextController.addListener(_checkFormValidation);
    ever(recordedAudioPath, (_) => _checkFormValidation());

    syncScenario();
    _checkFormValidation();
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
    interviewKeywordsController.removeListener(_checkFormValidation);
    roleApplyingController.removeListener(_checkFormValidation);
    voiceAnswerTextController.removeListener(_checkFormValidation);
    interviewKeywordsController.dispose();
    roleApplyingController.dispose();
    voiceAnswerTextController.dispose();
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    _audioRecorder?.dispose().catchError((_) {});
    super.onClose();
  }

  // Real-time microphone amplitude listener
  void _startAmplitudeListening() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 65), (
      _,
    ) async {
      if (!isRecording.value) {
        _amplitudeTimer?.cancel();
        currentVolume.value = 0.0;
        isVoiceDetected.value = false;
        return;
      }
      try {
        final amp = await audioRecorder.getAmplitude();
        final currentDb = amp.current; // dBFS: typically -160 dB to 0 dB
        // Human voice typically ranges between -45 dB and -10 dB
        double vol = 0.0;
        if (currentDb > -45.0) {
          vol = ((currentDb + 45.0) / 35.0).clamp(0.0, 1.0);
        }
        // Smooth transitions with exponential moving average
        final smoothed = (currentVolume.value * 0.35) + (vol * 0.65);
        currentVolume.value = smoothed.clamp(0.0, 1.0);
        isVoiceDetected.value = currentVolume.value > 0.12;
      } catch (_) {
        // Fallback for simulators or restricted platforms
      }
    });
  }

  // Request microphone permission explicitly and return true if granted
  Future<bool> _requestMicrophonePermission() async {
    try {
      PermissionStatus status = await Permission.microphone.status;
      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        _showSafeSnackbar(
          'Microphone Access Required',
          'Please enable microphone access in your device settings to record voice.',
          durationSeconds: 4,
          mainButton: TextButton(
            onPressed: () => openAppSettings(),
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        AppLoggerHelper.warning(
          'Microphone permission permanently denied. Directing user to settings.',
        );
        return false;
      }

      status = await Permission.microphone.request();
      if (status.isGranted) return true;

      _showSafeSnackbar(
        'Microphone Access Denied',
        'Voice recording requires microphone access. Please allow it to continue.',
        durationSeconds: 3,
      );
      AppLoggerHelper.warning('Microphone permission denied by user.');
      return false;
    } catch (e) {
      AppLoggerHelper.warning('Microphone permission error: $e');
      return true;
    }
  }

  // Start audio recording — records as AAC-LC inside an MP4 container (.m4a)
  Future<void> startRecording() async {
    if (isRecording.value) return;

    final granted = await _requestMicrophonePermission();
    if (!granted) {
      AppLoggerHelper.warning(
        'Recording skipped — microphone permission not granted.',
      );
      return;
    }

    isRecording.value = true;
    recordDuration.value = 0;
    currentVolume.value = 0.0;
    isVoiceDetected.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      recordDuration.value++;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/step2_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000, // 128 kbps
          sampleRate: 44100, // 44.1 kHz standard sample rate
          numChannels: 1, // Mono
        ),
        path: filePath,
      );
      _startAmplitudeListening();
      AppLoggerHelper.info(
        'Started AAC voice recording to: $filePath',
      );
    } catch (e) {
      isRecording.value = false;
      _timer?.cancel();
      AppLoggerHelper.error('Error starting audio recording: $e', e);
    }
  }

  // Stop audio recording and return the recorded .m4a file path
  Future<String?> stopRecording() async {
    if (!isRecording.value) {
      return recordedAudioPath.value.isNotEmpty
          ? recordedAudioPath.value
          : null;
    }

    if (recordDuration.value == 0) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    isRecording.value = false;
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    currentVolume.value = 0.0;
    isVoiceDetected.value = false;

    try {
      final path = await audioRecorder.stop();
      if (path != null && path.isNotEmpty) {
        recordedAudioPath.value = path;
        AppLoggerHelper.info('Stopped AAC voice recording. Saved at: $path');
        return path;
      }
    } catch (e) {
      AppLoggerHelper.error('Error during stop recording: $e', e);
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
      final first = stored.split(' ').first;
      if (first.isNotEmpty) {
        return '${first[0].toUpperCase()}${first.substring(1)}';
      }
    }
    if (Get.isRegistered<StartGoalsController>()) {
      final name = Get.find<StartGoalsController>().userName.value.trim();
      if (name.isNotEmpty) {
        final first = name.split(' ').first;
        if (first.isNotEmpty) {
          return '${first[0].toUpperCase()}${first.substring(1)}';
        }
      }
    }
    return 'Aycan';
  }

  Future<void> submitDetailsAndProceed() async {
    // Automatically stop voice recording if currently active
    if (isRecording.value) {
      AppLoggerHelper.info(
        'Continue pressed while recording. Automatically stopping voice recording...',
      );
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
    final voicePath =
        recordedAudioPath.value.trim().isNotEmpty &&
            File(recordedAudioPath.value.trim()).existsSync()
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

    isAiResponseReceived.value = false;
    isProcessingBriefing.value = true;

    // Start background API call with a 60-second safety timeout
    _apiFuture = _briefingService
        .getPersonalBriefing(request)
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            AppLoggerHelper.warning(
              'Personal Briefing API timed out after 60s',
            );
            return null;
          },
        );

    _apiFuture!
        .then((result) {
          _cachedBriefing = result;
          isAiResponseReceived.value = true;
        })
        .catchError((err) {
          AppLoggerHelper.error('Personal Briefing API error: $err', err);
          isAiResponseReceived.value = true;
        });

    AppLoggerHelper.info(
      'Starting Personal Briefing preparation for scenario: ${selectedGoalTitle.value} (${selectedScenarioSlug.value})\n'
      'Voice File Path: ${voicePath ?? "None"}',
    );
  }

  Future<void> onProcessingComplete() async {
    try {
      if (_apiFuture != null) {
        _cachedBriefing = await _apiFuture;
      }

      final firstName = _getUserFirstName();
      final scenario = selectedGoalTitle.value;

      final briefingController = Get.isRegistered<StartBriefingController>()
          ? Get.find<StartBriefingController>()
          : Get.put(StartBriefingController());

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
        AppLoggerHelper.warning(
          'Personal Briefing API returned null or unsupported scenario. Using personalized fallback for: $scenario',
        );

        final role = roleApplyingController.text.trim().isNotEmpty
            ? roleApplyingController.text.trim()
            : roleFieldHint.value
                  .replaceFirst(RegExp(r'^e\.g\.\s*'), '')
                  .trim();
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
