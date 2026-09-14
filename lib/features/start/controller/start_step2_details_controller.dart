import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../../../routes/app_routes.dart';

class StartStep2DetailsController extends GetxController {
  late final TextEditingController interviewKeywordsController;
  late final TextEditingController roleApplyingController;
  late final TextEditingController voiceAnswerTextController;

  // Real Audio Recorder
  AudioRecorder? _audioRecorder;
  AudioRecorder get audioRecorder => _audioRecorder ??= AudioRecorder();

  // Voice recording state
  final RxBool isRecording = false.obs;
  final RxInt recordDuration = 0.obs;
  final RxString recordedAudioPath = ''.obs;
  final RxBool isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    interviewKeywordsController = TextEditingController(
      text:
          'I have a job interview coming up and I want to walk in with complete authority and conviction.',
    );
    roleApplyingController = TextEditingController();
    voiceAnswerTextController = TextEditingController();
  }

  @override
  void onClose() {
    interviewKeywordsController.dispose();
    roleApplyingController.dispose();
    voiceAnswerTextController.dispose();
    _timer?.cancel();
    _audioRecorder?.dispose();
    super.onClose();
  }

  // Toggle audio recording
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
      recordDuration.value = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        recordDuration.value++;
      });

      try {
        if (await audioRecorder.hasPermission()) {
          final dir = await getApplicationDocumentsDirectory();
          final filePath =
              '${dir.path}/step2_voice_answer_${DateTime.now().millisecondsSinceEpoch}.m4a';

          await audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: filePath,
          );
        }
      } catch (e) {
        debugPrint('Step 2 voice record native status: $e');
      }
    }
  }

  final RxBool isProcessingBriefing = false.obs;

  void submitDetailsAndProceed() {
    isProcessingBriefing.value = true;
  }

  void onProcessingComplete() {
    isProcessingBriefing.value = false;
    Get.toNamed(AppRoute.startBriefing);
  }
}
