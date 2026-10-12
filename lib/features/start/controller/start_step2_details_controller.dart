import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
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
  final RxDouble currentVolume = 0.0.obs; // 0.0 to 1.0 real-time microphone volume
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

  @override
  void onInit() {
    super.onInit();
    // Initially text fields are empty as requested ("intialy textfiled is null , user can text here")
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
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 65), (_) async {
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
    // First check current status
    PermissionStatus status = await Permission.microphone.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      // User has permanently denied — direct to settings
      Get.snackbar(
        'Microphone Access Required',
        'Please enable microphone access in your device settings to record voice.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
        mainButton: TextButton(
          onPressed: () => openAppSettings(),
          child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
        ),
      );
      AppLoggerHelper.warning('Microphone permission permanently denied. Directing user to settings.');
      return false;
    }

    // Request permission
    status = await Permission.microphone.request();
    if (status.isGranted) return true;

    Get.snackbar(
      'Microphone Access Denied',
      'Voice recording requires microphone access. Please allow it to continue.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
    AppLoggerHelper.warning('Microphone permission denied by user.');
    return false;
  }

  // Start audio recording — records as AAC-LC inside an MP4 container (.mp4)
  // Backend receives audio/mp4 which is widely supported
  Future<void> startRecording() async {
    // Guard: don't start a new recording if already recording
    if (isRecording.value) return;

    // Request permission explicitly before trying to record
    final granted = await _requestMicrophonePermission();
    if (!granted) {
      AppLoggerHelper.warning('Recording skipped — microphone permission not granted.');
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
      // Record as AAC-LC in .m4a — universally supported, will be converted to MP3
      final filePath =
          '${dir.path}/step2_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,   // 128 kbps — good quality for speech
          sampleRate: 44100, // 44.1 kHz standard sample rate
          numChannels: 1,    // Mono — sufficient for voice, smaller file size
        ),
        path: filePath,
      );
      _startAmplitudeListening();
      AppLoggerHelper.info('Started AAC voice recording to: $filePath (will convert to MP3)');
    } catch (e) {
      isRecording.value = false;
      _timer?.cancel();
      AppLoggerHelper.error('Error starting audio recording: $e', e);
    }
  }

  // Stop audio recording, then convert AAC/M4A → MP3 for the backend
  // Enforces a 500ms minimum to prevent zero-byte files on fast taps
  Future<String?> stopRecording() async {
    if (!isRecording.value) {
      return recordedAudioPath.value.isNotEmpty
          ? recordedAudioPath.value
          : null;
    }

    // Minimum 500ms guard — prevents empty/corrupt file on instant tap-stop
    if (recordDuration.value == 0) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    isRecording.value = false;
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    currentVolume.value = 0.0;
    isVoiceDetected.value = false;

    try {
      final aacPath = await audioRecorder.stop();
      if (aacPath == null || aacPath.isEmpty) {
        return recordedAudioPath.value.isNotEmpty ? recordedAudioPath.value : null;
      }

      // Immediately store the recorded audio path as the baseline.
      // This ensures the recording is NEVER lost if FFmpeg is unavailable or fails.
      recordedAudioPath.value = aacPath;
      AppLoggerHelper.info('Stopped AAC recording at: $aacPath');

      // Attempt FFmpeg conversion to MP3
      try {
        final mp3Path = aacPath.replaceAll(RegExp(r'\.(m4a|mp4|aac)$'), '.mp3');
        AppLoggerHelper.info('Attempting MP3 conversion: $mp3Path');

        // FFmpeg: transcode AAC → MP3 (128 kbps, mono, 44100 Hz)
        // -y         : overwrite output if it exists
        // -i         : input file
        // -vn        : no video stream
        // -ar 44100  : sample rate
        // -ac 1      : mono channel
        // -b:a 128k  : 128 kbps audio bitrate
        final session = await FFmpegKit.execute(
          '-y -i "$aacPath" -vn -ar 44100 -ac 1 -b:a 128k "$mp3Path"',
        );
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          final mp3File = File(mp3Path);
          if (await mp3File.exists() && await mp3File.length() > 0) {
            // Delete the intermediate AAC file to save storage
            try { await File(aacPath).delete(); } catch (_) {}
            recordedAudioPath.value = mp3Path;
            AppLoggerHelper.info('MP3 conversion successful: $mp3Path');
            return mp3Path;
          }
        }

        final logs = await session.getLogsAsString();
        AppLoggerHelper.warning(
          'MP3 conversion failed (rc=$returnCode). Falling back to recorded audio: $aacPath\nFFmpeg logs: $logs',
        );
      } catch (ffmpegErr) {
        AppLoggerHelper.warning(
          'FFmpeg conversion unavailable ($ffmpegErr). Falling back to recorded audio: $aacPath (Requires full app rebuild to link FFmpeg native binary).',
        );
      }

      return recordedAudioPath.value;
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

    isAiResponseReceived.value = false;
    isProcessingBriefing.value = true;

    // Start background API call with a 60-second safety timeout (voice uploads need extra time)
    _apiFuture = _briefingService
        .getPersonalBriefing(request)
        .timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            AppLoggerHelper.warning('Personal Briefing API timed out after 60s');
            return null;
          },
        );

    _apiFuture!.then((result) {
      _cachedBriefing = result;
      isAiResponseReceived.value = true;
    }).catchError((err) {
      AppLoggerHelper.error('Personal Briefing API error: $err', err);
      isAiResponseReceived.value = true;
    });

    // Show preparation modal
    AppLoggerHelper.info(
      'Starting Personal Briefing preparation for scenario: ${selectedGoalTitle.value} (${selectedScenarioSlug.value})\n'
      'Voice File Path: ${voicePath ?? "None"}',
    );
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
