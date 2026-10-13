import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_question_model.dart';

class PracticeQuestionController extends GetxController {
  final Rx<PracticeQuestionModel> questionData =
      PracticeQuestionModel.initial().obs;

  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  final RxBool isRecording = false.obs;
  final RxInt recordingSeconds = 0.obs;
  final RxBool isPlayingQuestionAudio = false.obs;
  final RxString recordedAudioPath = ''.obs;
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
          '${dir.path}/question1_${DateTime.now().millisecondsSinceEpoch}.m4a';

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
      AppLoggerHelper.error('Error starting question recording: $e');
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
      AppLoggerHelper.error('Error stopping question recording: $e');
    } finally {
      isRecording.value = false;
      EasyLoading.showSuccess('Answer recorded successfully!');
    }
  }

  void replayQuestion() {
    isPlayingQuestionAudio.value = true;
    EasyLoading.showToast('Replaying question audio...');
    Future.delayed(const Duration(seconds: 3), () {
      isPlayingQuestionAudio.value = false;
    });
  }

  void openGuidance() {
    Get.toNamed(AppRoute.practiceCuesGuidance);
  }
}
