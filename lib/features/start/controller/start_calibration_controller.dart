import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../routes/app_routes.dart';

class StartCalibrationController extends GetxController {
  // Real Audio Recorder
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  final RxBool isRecording = false.obs;
  final RxInt durationSeconds = 0.obs;
  final RxString recordedAudioPath = ''.obs;
  final RxBool isLoading = false.obs;
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
      isRecording.value = false;
      _timer?.cancel();
      try {
        final path = await audioRecorder.stop();
        if (path != null) {
          recordedAudioPath.value = path;
        }
      } catch (_) {}
    } else {
      isRecording.value = true;
      durationSeconds.value = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (durationSeconds.value >= 60) {
          await toggleRecording();
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
        }
      } catch (e) {
        debugPrint('Voice calibration native status: $e');
      }
    }
  }

  final RxBool isCalculating = false.obs;

  void proceedToStep5() {
    isCalculating.value = true;
  }

  void onCalculationComplete() {
    isCalculating.value = false;
    Get.toNamed(AppRoute.startStep5Score);
  }
}
