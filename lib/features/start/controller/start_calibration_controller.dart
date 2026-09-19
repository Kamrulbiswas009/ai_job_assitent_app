import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../../core/utils/logging/logger.dart';
import '../../../../routes/app_routes.dart';
import '../service/assessment_service.dart';

class StartCalibrationController extends GetxController {
  final AssessmentService _assessmentService;

  StartCalibrationController({AssessmentService? assessmentService})
      : _assessmentService = assessmentService ?? AssessmentService();

  // Real Audio Recorder
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  final RxBool isRecording = false.obs;
  final RxInt durationSeconds = 0.obs;
  final RxString recordedAudioPath = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isCalculating = false.obs;
  Timer? _timer;

  @override
  void onClose() {
    _timer?.cancel();
    _audioRecorder?.dispose();
    super.onClose();
  }

  // Real Voice calibration recording toggle (60s max)
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  Future<void> startRecording() async {
    isRecording.value = true;
    durationSeconds.value = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (durationSeconds.value >= 60) {
        await stopRecording();
      } else {
        durationSeconds.value++;
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
        AppLoggerHelper.info('Started calibration voice recording to: $filePath');
      } else {
        AppLoggerHelper.warning('Microphone permission not granted for voice calibration');
      }
    } catch (e) {
      AppLoggerHelper.error('Error starting voice calibration recording: $e', e);
    }
  }

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
        AppLoggerHelper.info('Stopped calibration voice recording. Saved at: $path');
        return path;
      }
    } catch (e) {
      AppLoggerHelper.error('Error stopping calibration recording: $e', e);
    }
    return recordedAudioPath.value.isNotEmpty ? recordedAudioPath.value : null;
  }

  /// Submits the recorded voice to POST /api/v1/assessment/{assessment_id}/voice
  /// and opens the ScoreCalculationModal
  Future<void> submitVoiceAndProceed() async {
    if (isRecording.value) {
      AppLoggerHelper.info('Continue pressed while recording. Automatically stopping recording...');
      await stopRecording();
    }

    final path = recordedAudioPath.value;
    if (path.isEmpty || !File(path).existsSync()) {
      if (Get.context != null) {
        Get.snackbar(
          'Voice Recording Needed',
          'Please tap to speak your answer before continuing, or tap "Skip Voice calibration".',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.black.withValues(alpha: 0.85),
          colorText: AppColors.white,
          margin: const EdgeInsets.all(16),
        );
      }
      return;
    }

    isLoading.value = true;

    try {
      final assessmentId = StorageService.assessmentId ?? '';
      if (assessmentId.isNotEmpty) {
        AppLoggerHelper.info('Submitting calibration voice for assessment_id: $assessmentId');
        final response = await _assessmentService.submitVoiceFile(
          assessmentId: assessmentId,
          filePath: path,
        );

        if (response != null && response.success) {
          AppLoggerHelper.info('Calibration voice successfully processed: ${response.message}');
        } else {
          AppLoggerHelper.warning('Calibration voice submission returned non-success or null');
        }
      } else {
        AppLoggerHelper.warning(
          'No assessmentId found in storage. Proceeding with calibration score calculation directly.',
        );
      }
    } catch (e) {
      AppLoggerHelper.error('Unexpected error while submitting calibration voice: $e', e);
    } finally {
      isLoading.value = false;
      // Navigate to Score Calculation Modal
      isCalculating.value = true;
    }
  }

  Future<void> skipCalibration() async {
    if (isRecording.value) {
      await stopRecording();
    }
    isCalculating.value = true;
  }

  void proceedToStep5() {
    skipCalibration();
  }

  void onCalculationComplete() {
    isCalculating.value = false;
    Get.toNamed(AppRoute.startStep5Score);
  }
}
