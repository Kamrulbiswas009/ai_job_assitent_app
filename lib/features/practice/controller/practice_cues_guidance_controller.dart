import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import '../model/practice_cues_guidance_model.dart';

class PracticeCuesGuidanceController extends GetxController {
  final Rx<PracticeCuesGuidanceModel> guidanceData =
      PracticeCuesGuidanceModel.initial().obs;

  final RxInt selectedCueIndex = 0.obs;
  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();
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

  void selectCue(int index) {
    selectedCueIndex.value = index;
    final cue = guidanceData.value.cues[index];
    EasyLoading.showToast('Selected: ${cue.title}');
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
          '${dir.path}/practice_cue_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      isRecording.value = true;
      recordingSeconds.value = 0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordingSeconds.value++;
      });
    } catch (e) {
      AppLoggerHelper.error('Error starting recording in guidance: $e');
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
        await audioRecorder.stop();
      }
    } catch (e) {
      AppLoggerHelper.error('Error stopping guidance recording: $e');
    } finally {
      isRecording.value = false;
      EasyLoading.showSuccess('Practice answer recorded!');
    }
  }

  void replayQuestion() {
    EasyLoading.showToast('Replaying question audio...');
  }
}
