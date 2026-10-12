import 'dart:async';
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../../../../core/services/storage_service.dart';
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
  final RxDouble currentVolume = 0.0.obs; // 0.0 to 1.0 real-time microphone volume
  final RxBool isVoiceDetected = false.obs;
  Timer? _timer;
  Timer? _amplitudeTimer;

  @override
  void onClose() {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
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
    PermissionStatus status = await Permission.microphone.status;
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
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

  // Starts a new recording session (AAC-LC into .m4a, converted to .mp3 on stop)
  // Auto-stops at 60 seconds
  Future<void> startRecording() async {
    // Guard: don't start a new recording if already active
    if (isRecording.value) return;

    // Request permission explicitly
    final granted = await _requestMicrophonePermission();
    if (!granted) {
      AppLoggerHelper.warning('Calibration recording skipped — microphone permission not granted.');
      return;
    }

    isRecording.value = true;
    durationSeconds.value = 0;
    currentVolume.value = 0.0;
    isVoiceDetected.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (durationSeconds.value >= 60) {
        await stopRecording(); // auto-stop at 60s (includes MP3 conversion)
      } else {
        durationSeconds.value++;
      }
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      // Record as AAC-LC in .m4a — universally supported, converted to MP3 after stop
      final filePath =
          '${dir.path}/calibration_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,   // 128 kbps — good quality for speech
          sampleRate: 44100, // 44.1 kHz standard
          numChannels: 1,    // Mono — sufficient for voice
        ),
        path: filePath,
      );
      _startAmplitudeListening();
      AppLoggerHelper.info(
        'Started calibration voice recording to: $filePath (will convert to MP3)',
      );
    } catch (e) {
      isRecording.value = false;
      _timer?.cancel();
      AppLoggerHelper.error(
        'Error starting voice calibration recording: $e',
        e,
      );
    }
  }

  // Stop recording and convert AAC/M4A → MP3 for the backend
  // Backend endpoint: POST /api/v1/assessment/{id}/voice accepts mp3
  Future<String?> stopRecording() async {
    if (!isRecording.value) {
      return recordedAudioPath.value.isNotEmpty
          ? recordedAudioPath.value
          : null;
    }

    // Minimum 500ms guard — prevents zero-byte file on instant tap-stop
    if (durationSeconds.value == 0) {
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
      AppLoggerHelper.info('Stopped calibration recording at: $aacPath');

      // Attempt FFmpeg conversion to MP3
      try {
        final mp3Path = aacPath.replaceAll(RegExp(r'\.(m4a|mp4|aac)$'), '.mp3');
        AppLoggerHelper.info('Attempting MP3 conversion: $mp3Path');

        // FFmpeg: transcode AAC → MP3 (128 kbps, mono, 44100 Hz)
        final session = await FFmpegKit.execute(
          '-y -i "$aacPath" -vn -ar 44100 -ac 1 -b:a 128k "$mp3Path"',
        );
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          final mp3File = File(mp3Path);
          if (await mp3File.exists() && await mp3File.length() > 0) {
            // Delete intermediate AAC file to save storage
            try { await File(aacPath).delete(); } catch (_) {}
            recordedAudioPath.value = mp3Path;
            AppLoggerHelper.info('Calibration MP3 conversion successful: $mp3Path');
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
      AppLoggerHelper.error('Error during calibration stop: $e', e);
    }
    return recordedAudioPath.value.isNotEmpty ? recordedAudioPath.value : null;
  }

  /// Submits the recorded voice to POST /api/v1/assessment/{assessment_id}/voice
  /// and opens the ScoreCalculationModal
  Future<void> submitVoiceAndProceed() async {
    if (isRecording.value) {
      AppLoggerHelper.info(
        'Continue pressed while recording. Automatically stopping recording...',
      );
      await stopRecording();
    }

    final path = recordedAudioPath.value;
    if (path.isEmpty || !File(path).existsSync()) {
      try {
        EasyLoading.showInfo(
          'Please tap to speak your answer before continuing, or tap "Skip Voice calibration".',
        ).catchError((_) {});
      } catch (_) {}
      return;
    }

    isLoading.value = true;

    try {
      final assessmentId = StorageService.assessmentId ?? '';
      if (assessmentId.isNotEmpty) {
        AppLoggerHelper.info(
          'Submitting calibration voice for assessment_id: $assessmentId',
        );
        final response = await _assessmentService.submitVoiceFile(
          assessmentId: assessmentId,
          filePath: path,
        );

        if (response != null && response.success) {
          AppLoggerHelper.info(
            'Calibration voice successfully processed: ${response.message}',
          );
          // Navigate to Score Calculation Modal only on successful voice analysis
          isCalculating.value = true;
        } else {
          final message = response?.message ??
              'No speech was detected in your recording. Please check your microphone and try again.';
          final hint = response?.hint;
          final displayText = hint != null && hint.isNotEmpty
              ? '$message\n\n$hint'
              : message;

          Get.snackbar(
            'Speech Not Detected',
            displayText,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF2C2C2E),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.mic_off, color: Colors.orangeAccent),
          );

          // Clear audio path so user can tap to re-record
          recordedAudioPath.value = '';
        }
      } else {
        AppLoggerHelper.warning(
          'No assessmentId found in storage. Proceeding with calibration score calculation directly.',
        );
        isCalculating.value = true;
      }
    } catch (e) {
      AppLoggerHelper.error(
        'Unexpected error while submitting calibration voice: $e',
        e,
      );
      Get.snackbar(
        'Submission Error',
        'Failed to process audio recording: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
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
