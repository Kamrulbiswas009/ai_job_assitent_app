import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/core/common/widgets/sp_loading_overlay.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_coach_feedback_model.dart';
import '../service/practice_session_service.dart';
import 'practice_question_controller.dart';

class PracticeAnswerReviewController extends GetxController {
  PracticeAnswerReviewController({PracticeSessionService? sessionService})
      : _sessionService = sessionService ?? PracticeSessionService();

  final PracticeSessionService _sessionService;

  final RxString audioPath = ''.obs;
  final RxBool isPlaying = false.obs;
  final RxInt recordedSeconds = 0.obs;
  final RxBool isSubmitting = false.obs;

  String get formattedPlaybackDuration {
    final total = recordedSeconds.value;
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get feedbackDurationLabel {
    final total = recordedSeconds.value;
    return '${total ~/ 60}:${(total % 60).toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    _applyArguments(Get.arguments);
  }

  void _applyArguments(dynamic args) {
    if (args is! Map) return;
    audioPath.value = args['audioPath']?.toString() ?? '';
    recordedSeconds.value = args['durationSeconds'] as int? ?? 0;
  }

  void togglePlayback() {
    final path = audioPath.value;
    if (path.isEmpty || !File(path).existsSync()) {
      EasyLoading.showInfo('No recording found. Record again.');
      return;
    }
    isPlaying.value = !isPlaying.value;
  }

  void onPlaybackCompleted() {
    isPlaying.value = false;
  }

  void recordAgain() {
    isPlaying.value = false;
    Get.offNamed(AppRoute.practiceAnswerRecord);
  }

  Future<void> submitAnswer() async {
    if (isSubmitting.value) return;

    final path = audioPath.value;
    if (path.isEmpty || !File(path).existsSync()) {
      EasyLoading.showInfo('No recording found. Record again.');
      return;
    }

    isSubmitting.value = true;
    isPlaying.value = false;
    SpLoadingOverlay.show(
      title: 'Your coach is reviewing',
      thoughts: const [
        'Listening to your answer…',
        'Noticing what landed…',
        'Shaping a note for next time…',
      ],
    );

    try {
      if (!Get.isRegistered<PracticeQuestionController>()) {
        SpLoadingOverlay.hide();
        EasyLoading.showError('Could not submit your answer.');
        return;
      }

      final questionController = Get.find<PracticeQuestionController>();
      final request = questionController.buildEvaluateRequest(
        audioPath: path,
        durationSeconds: recordedSeconds.value,
      );
      final result = await _sessionService.evaluateAnswer(request);
      SpLoadingOverlay.hide();

      if (result == null) {
        EasyLoading.showError(
          'Could not evaluate your answer. Please try again.',
        );
        return;
      }

      if (!result.success) {
        EasyLoading.showError(
          result.whatLanded.isNotEmpty
              ? result.whatLanded
              : 'Could not evaluate your answer. Please record again.',
        );
        return;
      }

      Get.offNamedUntil(
        AppRoute.practiceCoachFeedback,
        (route) => route.settings.name == AppRoute.practiceQuestion,
        arguments: PracticeCoachFeedbackModel.fromEvaluate(
          result: result,
          questionIndex: questionController.currentQuestionNumber,
          totalQuestions: questionController.totalQuestionCount,
          durationLabel: feedbackDurationLabel,
          audioPath: path,
        ),
      );
    } catch (e) {
      SpLoadingOverlay.hide();
      AppLoggerHelper.error('Error submitting answer: $e', e);
      EasyLoading.showError('Could not submit your answer.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
