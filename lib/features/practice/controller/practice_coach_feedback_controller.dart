import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_coach_feedback_model.dart';
import 'practice_question_controller.dart';

class PracticeCoachFeedbackController extends GetxController {
  final Rx<PracticeCoachFeedbackModel> feedback =
      PracticeCoachFeedbackModel.forQuestion(
    questionIndex: 1,
    totalQuestions: 3,
    durationLabel: '0:00',
  ).obs;

  final RxBool isPlayingFeedback = false.obs;

  @override
  void onInit() {
    super.onInit();
    _applyArguments(Get.arguments);
  }

  void _applyArguments(dynamic args) {
    if (args is PracticeCoachFeedbackModel) {
      feedback.value = args;
      return;
    }
    if (args is Map) {
      feedback.value = PracticeCoachFeedbackModel.forQuestion(
        questionIndex: args['questionIndex'] as int? ?? 1,
        totalQuestions: args['totalQuestions'] as int? ?? 3,
        durationLabel: args['durationLabel']?.toString() ?? '0:00',
        audioPath: args['audioPath']?.toString() ?? '',
        youSaid: args['youSaid']?.toString(),
      );
    }
  }

  void toggleHearFeedback() {
    if (feedback.value.audioPath.trim().isEmpty) {
      EasyLoading.showToast('Playing coach feedback...');
      return;
    }
    isPlayingFeedback.value = !isPlayingFeedback.value;
  }

  void onPlaybackCompleted() {
    isPlayingFeedback.value = false;
  }

  void continueToNextQuestion() {
    isPlayingFeedback.value = false;

    if (!Get.isRegistered<PracticeQuestionController>()) {
      Get.until((route) => route.settings.name == AppRoute.practiceQuestion);
      return;
    }

    final questionController = Get.find<PracticeQuestionController>();
    final data = feedback.value;

    if (data.sessionComplete) {
      _openSessionComplete();
      return;
    }

    final moved = questionController.goToNextQuestion();
    if (moved && data.nextQuestion != null) {
      questionController.mergeCurrentFromEvaluate(data.nextQuestion!);
    }

    if (!moved) {
      if (questionController.questions.isEmpty) {
        Get.until((route) => route.settings.name == AppRoute.practiceQuestion);
        return;
      }
      _openSessionComplete();
      return;
    }

    Get.until((route) => route.settings.name == AppRoute.practiceQuestion);
  }

  void _openSessionComplete() {
    Get.offNamedUntil(
      AppRoute.practiceSessionComplete,
      (route) => route.settings.name == AppRoute.practiceSessionReady,
    );
  }
}
