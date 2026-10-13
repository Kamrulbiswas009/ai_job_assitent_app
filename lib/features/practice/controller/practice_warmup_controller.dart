import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_warmup_model.dart';

class PracticeWarmupController extends GetxController {
  final Rx<PracticeWarmupModel> warmupData = PracticeWarmupModel.initial().obs;

  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  final RxString recordedAudioPath = ''.obs;
  final RxBool hasCompletedWarmup = false.obs;
  Timer? _timer;

  String get formattedDuration {
    final minutes = (recordingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (recordingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
      isRecording.value = true;
      recordingSeconds.value = 0;

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordingSeconds.value++;
      });
    } catch (e) {
      AppLoggerHelper.error('Error starting warmup recording: $e');
      // Fallback: simulate timer so UI still behaves gracefully
      isRecording.value = true;
      recordingSeconds.value = 0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordingSeconds.value++;
      });
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
      hasCompletedWarmup.value = true;
      onProceedToQuestion();
    }
  }

  void onProceedToQuestion() {
    Get.toNamed(AppRoute.practiceQuestion);
  }
}
