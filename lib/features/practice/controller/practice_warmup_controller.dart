import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_warmup_model.dart';
import 'practice_coaching_brief_controller.dart';
import 'practice_question_controller.dart';

class PracticeWarmupController extends GetxController {
  final Rx<PracticeWarmupModel> warmupData = PracticeWarmupModel.initial().obs;

  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  final RxString recordedAudioPath = ''.obs;
  final RxBool hasRecording = false.obs;
  final RxBool isPlayingBack = false.obs;
  final RxBool hasCompletedWarmup = false.obs;
  Timer? _timer;

  String get formattedDuration {
    final minutes = (recordingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (recordingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();
    _initWarmupCopy();
    StorageService.saveCurrentSession(
      route: AppRoute.practiceWarmup,
      title: 'Voice Check',
    );
  }

  void _initWarmupCopy() {
    String? firstQuestion;
    if (Get.isRegistered<PracticeCoachingBriefController>()) {
      firstQuestion =
          Get.find<PracticeCoachingBriefController>().briefData.value.firstQuestion;
    }
    warmupData.value = PracticeWarmupModel.voiceCheck(
      promptQuestion: firstQuestion,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    _audioRecorder?.dispose().catchError((_) {});
    super.onClose();
  }

  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  Future<void> startRecording() async {
    isPlayingBack.value = false;

    try {
      final hasPermission = await audioRecorder.hasPermission();
      if (!hasPermission) {
        EasyLoading.showError('Microphone permission required');
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/warmup_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      recordedAudioPath.value = filePath;
      hasRecording.value = false;
      hasCompletedWarmup.value = false;
      isRecording.value = true;
      recordingSeconds.value = 0;

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordingSeconds.value++;
      });
    } catch (e) {
      AppLoggerHelper.error('Error starting warmup recording: $e');
      EasyLoading.showError('Could not start recording. Please try again.');
    }
  }

  Future<void> stopRecording() async {
    try {
      _timer?.cancel();
      if (await audioRecorder.isRecording()) {
        final path = await audioRecorder.stop();
        if (path != null && path.isNotEmpty) {
          recordedAudioPath.value = path;
        }
      }
    } catch (e) {
      AppLoggerHelper.error('Error stopping warmup recording: $e');
    } finally {
      isRecording.value = false;
      final path = recordedAudioPath.value;
      if (path.isNotEmpty && File(path).existsSync()) {
        hasRecording.value = true;
        hasCompletedWarmup.value = true;
      } else {
        EasyLoading.showInfo('No recording captured. Try again.');
      }
    }
  }

  void togglePlayback() {
    final path = recordedAudioPath.value;
    if (path.isEmpty || !File(path).existsSync()) {
      EasyLoading.showInfo('Record something first, then play it back.');
      return;
    }
    isPlayingBack.value = !isPlayingBack.value;
  }

  void onPlaybackCompleted() {
    isPlayingBack.value = false;
  }

  void recordAgain() {
    isPlayingBack.value = false;
    hasRecording.value = false;
    hasCompletedWarmup.value = false;
    recordingSeconds.value = 0;
    recordedAudioPath.value = '';
  }

  Future<void> onProceedToQuestion() async {
    isPlayingBack.value = false;

    final sessionId = _resolveBackendSessionId();
    if (sessionId.isEmpty) {
      EasyLoading.showError(
        'Session not found. Please start the session again.',
      );
      return;
    }

    if (Get.isRegistered<PracticeQuestionController>()) {
      Get.find<PracticeQuestionController>().loadQuestions(sessionId);
    }

    Get.toNamed(
      AppRoute.practiceQuestion,
      arguments: {'sessionId': sessionId},
    );
  }

  String _resolveBackendSessionId() {
    if (Get.isRegistered<PracticeCoachingBriefController>()) {
      final id =
          Get.find<PracticeCoachingBriefController>().backendSessionId.value;
      if (id.trim().isNotEmpty) return id.trim();
    }

    final session = StorageService.getLastSession();
    final stored = session?.arguments?['backendSessionId']?.toString();
    return stored?.trim() ?? '';
  }
}
