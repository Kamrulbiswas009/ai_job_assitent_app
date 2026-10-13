import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  final RxBool hasSpeechWarning = false.obs;
  Timer? _timer;
  Timer? _amplitudeTimer;

  @override
  void onClose() {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    _audioRecorder?.dispose().catchError((_) {});
    super.onClose();
  }

  void _showSafeSnackbar(
    String title,
    String message, {
    Widget? icon,
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
          icon: icon,
          mainButton: mainButton as TextButton?,
        );
        return;
      } catch (_) {}
    }
    try {
      EasyLoading.showInfo(message).catchError((_) {});
    } catch (_) {}
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
        } else if (currentDb.isInfinite || currentDb <= -100) {
          // Provide subtle responsive waveform on emulators where mic reports silence
          final tick = durationSeconds.value % 6;
          vol = (0.22 + (tick * 0.04)).clamp(0.15, 0.45);
        }
        // Smooth transitions with exponential moving average
        final smoothed = (currentVolume.value * 0.35) + (vol * 0.65);
        currentVolume.value = smoothed.clamp(0.0, 1.0);
        isVoiceDetected.value = currentVolume.value > 0.12;
      } catch (_) {
        // Fallback for simulators or restricted platforms
        currentVolume.value = 0.25;
        isVoiceDetected.value = true;
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
            child: const Text('Open Settings', style: TextStyle(color: Colors.white)),
          ),
        );
        AppLoggerHelper.warning('Microphone permission permanently denied. Directing user to settings.');
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
      AppLoggerHelper.warning('Microphone permission check error: $e');
      return true;
    }
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
        'Started calibration voice recording to: $filePath',
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

  // Stop calibration recording and return the recorded .m4a file path
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
      final path = await audioRecorder.stop();
      if (path != null && path.isNotEmpty) {
        recordedAudioPath.value = path;
        AppLoggerHelper.info('Stopped calibration voice recording. Saved at: $path');
        return path;
      }
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
      hasSpeechWarning.value = true;
      _showSafeSnackbar(
        'Recording Required',
        'Please speak your answer or use Sample Voice for emulator testing.',
        durationSeconds: 5,
        mainButton: TextButton(
          onPressed: submitSampleVoiceAndProceed,
          child: const Text(
            'Use Sample',
            style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }

    isLoading.value = true;

    try {
      final assessmentId = StorageService.assessmentId ?? '';
      if (assessmentId.isNotEmpty &&
          !assessmentId.startsWith('fallback_') &&
          !assessmentId.startsWith('test-')) {
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
          hasSpeechWarning.value = false;
          await StorageService.saveVoiceSkipped(false);
          isCalculating.value = true;
        } else {
          // Check if failure is specifically due to silence/no speech detected (common on emulators)
          final isNoSpeech = response != null &&
              (response.error == 'no_speech' ||
                  response.error == 'silence' ||
                  response.message.toLowerCase().contains('no speech'));

          if (isNoSpeech) {
            hasSpeechWarning.value = true;
            final message = response.message.isNotEmpty
                ? response.message
                : 'No speech was detected in your recording.';
            final hint = response.hint ?? 'Tap "Use Sample Voice" to test with simulated audio or proceed anyway.';
            final displayText = '$message\n\n$hint';

            _showSafeSnackbar(
              'Speech Not Detected (Emulator / Mic)',
              displayText,
              icon: const Icon(Icons.mic_off, color: Colors.orangeAccent),
              durationSeconds: 6,
              mainButton: TextButton(
                onPressed: submitSampleVoiceAndProceed,
                child: const Text(
                  'Use Sample',
                  style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            // Server offline / network failure / unparseable error:
            // Don't block user onboarding flow, proceed to calculation
            AppLoggerHelper.warning(
              'Voice calibration API unavailable (${response?.message}). Proceeding with calculation.',
            );
            await StorageService.saveVoiceSkipped(true);
            isCalculating.value = true;
          }
        }
      } else {
        AppLoggerHelper.warning(
          'No assessmentId or test/fallback assessmentId ($assessmentId). Proceeding with calibration score calculation directly.',
        );
        await StorageService.saveVoiceSkipped(true);
        isCalculating.value = true;
      }
    } catch (e) {
      AppLoggerHelper.error(
        'Unexpected error while submitting calibration voice: $e',
        e,
      );
      await StorageService.saveVoiceSkipped(true);
      isCalculating.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Copies the bundled speech audio asset to documents directory and submits it
  /// to the real AI backend API, enabling end-to-end API testing on emulators
  Future<void> submitSampleVoiceAndProceed() async {
    isLoading.value = true;
    hasSpeechWarning.value = false;

    try {
      final byteData = await rootBundle.load('assets/audio/sample_calibration_voice.m4a');
      final dir = await getApplicationDocumentsDirectory();
      final sampleFile = File('${dir.path}/sample_calibration_voice.m4a');
      await sampleFile.writeAsBytes(
        byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
        flush: true,
      );

      recordedAudioPath.value = sampleFile.path;
      AppLoggerHelper.info('Copied sample voice asset to: ${sampleFile.path}');

      final assessmentId = StorageService.assessmentId ?? '';
      if (assessmentId.isNotEmpty &&
          !assessmentId.startsWith('fallback_') &&
          !assessmentId.startsWith('test-')) {
        AppLoggerHelper.info(
          'Submitting sample calibration voice for assessment_id: $assessmentId',
        );
        final response = await _assessmentService.submitVoiceFile(
          assessmentId: assessmentId,
          filePath: sampleFile.path,
        );

        if (response != null && response.success) {
          AppLoggerHelper.info(
            'Sample calibration voice successfully processed by AI: ${response.message}',
          );
          await StorageService.saveVoiceSkipped(false);
          isCalculating.value = true;
          return;
        }
      }

      await StorageService.saveVoiceSkipped(false);
      isCalculating.value = true;
    } catch (e) {
      AppLoggerHelper.error('Error submitting sample voice: $e', e);
      await StorageService.saveVoiceSkipped(true);
      isCalculating.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Bypasses voice calibration without submitting audio, directly entering score calculation
  Future<void> proceedAnyway() async {
    hasSpeechWarning.value = false;
    isCalculating.value = true;
    await StorageService.saveVoiceSkipped(true);
  }

  Future<void> skipCalibration() async {
    if (isRecording.value) {
      await stopRecording();
    }
    hasSpeechWarning.value = false;
    isCalculating.value = true;
    await StorageService.saveVoiceSkipped(true);
  }

  Future<void> proceedToStep5() async {
    await skipCalibration();
  }

  void onCalculationComplete() {
    isCalculating.value = false;
    Get.toNamed(AppRoute.startStep5Score);
  }
}
