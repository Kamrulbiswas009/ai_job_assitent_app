import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import 'practice_question_controller.dart';

class PracticeAnswerRecordController extends GetxController {
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  final RxBool isRecording = false.obs;
  final RxInt durationSeconds = 0.obs;
  final RxDouble currentVolume = 0.0.obs;
  final RxBool isVoiceDetected = false.obs;
  final RxString recordedAudioPath = ''.obs;

  Timer? _timer;
  Timer? _amplitudeTimer;

  static const int maxDurationSeconds = 60;
  static const _demoVoices = [
    _PracticeDemoVoice(
      asset: 'assets/audio/practice_demo_q1.m4a',
      durationSeconds: 11,
    ),
    _PracticeDemoVoice(
      asset: 'assets/audio/practice_demo_q2.m4a',
      durationSeconds: 12,
    ),
    _PracticeDemoVoice(
      asset: 'assets/audio/practice_demo_q3.m4a',
      durationSeconds: 12,
    ),
  ];

  final RxBool isUsingDemo = false.obs;

  int get demoQuestionNumber {
    if (!Get.isRegistered<PracticeQuestionController>()) return 1;
    return Get.find<PracticeQuestionController>().currentQuestionNumber;
  }

  String get demoVoiceButtonLabel =>
      'Use demo voice for Question $demoQuestionNumber';

  _PracticeDemoVoice get _demoForCurrentQuestion {
    final index = (demoQuestionNumber - 1).clamp(0, _demoVoices.length - 1);
    return _demoVoices[index % _demoVoices.length];
  }

  String get formattedDuration {
    final minutes = (durationSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onReady() {
    super.onReady();
    startRecording();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
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

  Future<void> useDemoVoice() async {
    if (isUsingDemo.value) return;
    isUsingDemo.value = true;

    _timer?.cancel();
    _amplitudeTimer?.cancel();
    currentVolume.value = 0.0;
    isVoiceDetected.value = false;

    if (isRecording.value) {
      isRecording.value = false;
      try {
        await audioRecorder.stop();
      } catch (_) {}
    }

    try {
      final demo = _demoForCurrentQuestion;
      final questionNumber = demoQuestionNumber;
      final bytes = await rootBundle.load(demo.asset);
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/practice_demo_answer_q$questionNumber.m4a',
      );
      await file.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        flush: true,
      );

      if (!file.existsSync() || file.lengthSync() == 0) {
        throw Exception('Demo voice file is empty.');
      }

      recordedAudioPath.value = file.path;
      durationSeconds.value = demo.durationSeconds;
      AppLoggerHelper.info(
        'Using bundled demo voice for question $questionNumber at ${file.path}',
      );

      Get.offNamed(
        AppRoute.practiceAnswerReview,
        arguments: {
          'audioPath': file.path,
          'durationSeconds': demo.durationSeconds,
        },
      );
    } catch (e) {
      AppLoggerHelper.error('Error loading demo voice: $e', e);
      EasyLoading.showError('Could not load demo voice. Try again.');
    } finally {
      isUsingDemo.value = false;
    }
  }

  Future<void> startRecording() async {
    if (isRecording.value || isUsingDemo.value) return;

    try {
      final hasPermission = await audioRecorder.hasPermission();
      if (!hasPermission) {
        EasyLoading.showError('Microphone permission required');
        return;
      }
      if (isUsingDemo.value) return;

      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/answer_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: filePath,
      );

      recordedAudioPath.value = filePath;
      isRecording.value = true;
      durationSeconds.value = 0;
      currentVolume.value = 0.0;
      isVoiceDetected.value = false;

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
        if (durationSeconds.value >= maxDurationSeconds) {
          await stopRecording();
        } else {
          durationSeconds.value++;
        }
      });
      _startAmplitudeListening();
    } catch (e) {
      isRecording.value = false;
      _timer?.cancel();
      AppLoggerHelper.error('Error starting answer recording: $e', e);
      EasyLoading.showError('Could not start recording. Please try again.');
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

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
      }
    } catch (e) {
      AppLoggerHelper.error('Error stopping answer recording: $e', e);
    }

    final path = recordedAudioPath.value;
    if (path.isEmpty || !File(path).existsSync()) {
      EasyLoading.showInfo('No recording captured. Try again.');
      return;
    }

    Get.offNamed(
      AppRoute.practiceAnswerReview,
      arguments: {'audioPath': path, 'durationSeconds': durationSeconds.value},
    );
  }

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
        final currentDb = amp.current;
        double vol = 0.0;
        if (currentDb > -45.0) {
          vol = ((currentDb + 45.0) / 35.0).clamp(0.0, 1.0);
        } else if (currentDb.isInfinite || currentDb <= -100) {
          final tick = durationSeconds.value % 6;
          vol = (0.22 + (tick * 0.04)).clamp(0.15, 0.45);
        }
        currentVolume.value =
            ((currentVolume.value * 0.35) + (vol * 0.65)).clamp(0.0, 1.0);
        isVoiceDetected.value = currentVolume.value > 0.12;
      } catch (_) {
        currentVolume.value = 0.25;
        isVoiceDetected.value = true;
      }
    });
  }
}

class _PracticeDemoVoice {
  const _PracticeDemoVoice({
    required this.asset,
    required this.durationSeconds,
  });

  final String asset;
  final int durationSeconds;
}
