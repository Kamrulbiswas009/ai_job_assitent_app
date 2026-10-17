import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/core/utils/logging/logger.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_evaluate_answer_model.dart';
import '../model/practice_question_model.dart';
import '../service/practice_session_service.dart';
import 'practice_coaching_brief_controller.dart';
import 'practice_cues_guidance_controller.dart';
import 'practice_session_ready_controller.dart';

class PracticeQuestionController extends GetxController {
  PracticeQuestionController({PracticeSessionService? sessionService})
      : _sessionService = sessionService ?? PracticeSessionService();

  final PracticeSessionService _sessionService;

  final Rx<PracticeQuestionModel> questionData =
      PracticeQuestionModel.initial().obs;

  final RxList<PracticeQuestionModel> questions = <PracticeQuestionModel>[].obs;
  final RxInt currentQuestionIndex = 0.obs;
  final RxString sessionId = ''.obs;
  final RxInt sessionNumber = 0.obs;
  final RxString scenarioName = ''.obs;
  final RxString panelName = ''.obs;
  final RxString sessionMode = ''.obs;
  final RxInt completedQuestions = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPlayingQuestionAudio = false.obs;

  int get currentQuestionNumber => currentQuestionIndex.value + 1;

  int get totalQuestionCount {
    if (questions.isNotEmpty) return questions.length;
    final total = questionData.value.totalQuestions;
    return total > 0 ? total : 1;
  }

  String get progressLabel =>
      'PRACTICE · QUESTION $currentQuestionNumber OF $totalQuestionCount';

  double get progressFraction {
    if (totalQuestionCount <= 0) return 0;
    return (currentQuestionNumber / totalQuestionCount).clamp(0.0, 1.0);
  }

  @override
  void onInit() {
    super.onInit();
    applyArguments(Get.arguments);
    StorageService.saveCurrentSession(
      route: AppRoute.practiceQuestion,
      title: 'Interactive Roleplay',
    );
  }

  void applyArguments(dynamic args) {
    if (args is PracticeSessionQuestionsResult) {
      applySessionQuestions(args);
      return;
    }
    if (args is Map) {
      if (args['questions'] is PracticeSessionQuestionsResult) {
        applySessionQuestions(
          args['questions'] as PracticeSessionQuestionsResult,
        );
        return;
      }
      final id = args['sessionId']?.toString().trim() ?? '';
      if (id.isNotEmpty) {
        loadQuestions(id);
      }
    }
  }

  Future<void> loadQuestions(String id) async {
    if (id.trim().isEmpty) return;
    sessionId.value = id.trim();
    isLoading.value = true;

    try {
      final result = await _sessionService.fetchSessionQuestions(id.trim());
      if (result == null || result.questions.isEmpty) {
        EasyLoading.showError(
          'Could not load practice questions. Please try again.',
        );
        return;
      }
      applySessionQuestions(result);
    } catch (e) {
      AppLoggerHelper.error('Failed to load practice questions: $e', e);
      EasyLoading.showError(
        'Could not load practice questions. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applySessionQuestions(PracticeSessionQuestionsResult result) {
    sessionId.value = result.sessionId;
    sessionNumber.value = result.sessionNumber;
    scenarioName.value = result.scenarioName;
    panelName.value = result.panelName;
    sessionMode.value = result.mode;
    completedQuestions.value = result.completedQuestions;
    questions.assignAll(result.questions);
    if (result.questions.isEmpty) return;

    final pendingIndex = result.questions.indexWhere(
      (item) => item.questionIndex > result.completedQuestions,
    );
    currentQuestionIndex.value = pendingIndex >= 0 ? pendingIndex : 0;
    _setCurrentQuestion(result.questions[currentQuestionIndex.value]);
    isLoading.value = false;
  }

  void _setCurrentQuestion(PracticeQuestionModel source) {
    questionData.value = source.copyWith(
      questionIndex: currentQuestionNumber,
      totalQuestions: totalQuestionCount,
      stepTag: progressLabel,
    );
    _attachRoleplayThumbnail();
  }

  void _attachRoleplayThumbnail() {
    if (!Get.isRegistered<PracticeSessionReadyController>()) return;
    final avatar =
        Get.find<PracticeSessionReadyController>().selectedRoleplay?.avatarUrl;
    if (avatar == null || avatar.isEmpty) return;
    questionData.value = questionData.value.copyWith(thumbnailUrl: avatar);
  }

  bool goToNextQuestion() {
    final next = currentQuestionIndex.value + 1;
    if (next >= questions.length) return false;
    currentQuestionIndex.value = next;
    completedQuestions.value = next;
    isPlayingQuestionAudio.value = false;
    _setCurrentQuestion(questions[next]);
    return true;
  }

  void mergeCurrentFromEvaluate(PracticeQuestionModel next) {
    final current = questionData.value;
    questionData.value = current.copyWith(
      questionText: next.questionText.isNotEmpty
          ? next.questionText
          : current.questionText,
      yourMove: next.yourMove.isNotEmpty ? next.yourMove : current.yourMove,
      supportTip: next.supportTip.isNotEmpty ? next.supportTip : current.supportTip,
      coachContext:
          next.coachContext.isNotEmpty ? next.coachContext : current.coachContext,
      headline: next.headline.isNotEmpty ? next.headline : current.headline,
      speakerRole:
          next.speakerRole.isNotEmpty ? next.speakerRole : current.speakerRole,
      questionId: next.questionId.isNotEmpty ? next.questionId : current.questionId,
      answerId: next.answerId.isNotEmpty ? next.answerId : current.answerId,
      roleplayerVideoUrl: next.roleplayerVideoUrl ?? current.roleplayerVideoUrl,
      roleplayerAudioUrl: next.roleplayerAudioUrl ?? current.roleplayerAudioUrl,
      cues: next.cues.isNotEmpty ? next.cues : current.cues,
    );
    _attachRoleplayThumbnail();
  }

  PracticeEvaluateAnswerRequest buildEvaluateRequest({
    required String audioPath,
    required int durationSeconds,
  }) {
    final current = questionData.value;
    final nextIndex = currentQuestionIndex.value + 1;
    final hasNext = nextIndex < questions.length;
    final next = hasNext ? questions[nextIndex] : null;

    String characterId = '';
    String challengeMode = sessionMode.value;
    if (Get.isRegistered<PracticeSessionReadyController>()) {
      final ready = Get.find<PracticeSessionReadyController>();
      characterId = ready.selectedRoleplay?.characterId ?? '';
      if (ready.selectedChallengeModeId.value.isNotEmpty) {
        challengeMode = ready.selectedChallengeModeId.value;
      }
    }

    return PracticeEvaluateAnswerRequest(
      audioPath: audioPath,
      questionIndex: currentQuestionNumber,
      questionId: current.questionId,
      answerId: current.answerId,
      sessionId: resolveBackendSessionId(),
      characterId: characterId,
      panelName: panelName.value.isNotEmpty
          ? panelName.value
          : (current.chips.length > 1 ? current.chips[1] : ''),
      challengeMode: challengeMode,
      mode: sessionMode.value,
      durationSeconds: durationSeconds,
      sessionNumber: sessionNumber.value,
      scenarioName: scenarioName.value.isNotEmpty
          ? scenarioName.value
          : (current.chips.isNotEmpty ? current.chips.first : ''),
      questionText: current.questionText,
      nextQuestionId: next?.questionId ?? '',
      nextQuestionText: next?.questionText ?? '',
      isLastQuestion: !hasNext,
      totalQuestions: totalQuestionCount,
      completedQuestions: completedQuestions.value,
      userId: StorageService.userId ?? '',
    );
  }

  void openAnswerRecord() {
    if (isLoading.value) return;
    Get.toNamed(
      AppRoute.practiceAnswerRecord,
      arguments: {
        'sessionId': sessionId.value,
        'answerId': questionData.value.answerId,
        'submitAnswerEndpoint': questionData.value.submitAnswerEndpoint,
      },
    );
  }

  void replayQuestion() {
    if (isLoading.value) return;
    isPlayingQuestionAudio.value = true;
    EasyLoading.showToast(
      questionData.value.hearQuestionAgainLabel,
    );
    Future.delayed(const Duration(seconds: 3), () {
      isPlayingQuestionAudio.value = false;
    });
  }

  void openGuidance({int cueIndex = 0}) {
    if (isLoading.value) return;
    if (Get.isRegistered<PracticeCuesGuidanceController>()) {
      Get.find<PracticeCuesGuidanceController>().selectCue(
        cueIndex,
        notify: false,
      );
    }
    Get.toNamed(
      AppRoute.practiceCuesGuidance,
      arguments: {'cueIndex': cueIndex},
    );
  }

  String resolveBackendSessionId() {
    if (sessionId.value.trim().isNotEmpty) return sessionId.value.trim();
    if (Get.isRegistered<PracticeCoachingBriefController>()) {
      final id =
          Get.find<PracticeCoachingBriefController>().backendSessionId.value;
      if (id.trim().isNotEmpty) return id.trim();
    }
    final stored =
        StorageService.getLastSession()?.arguments?['backendSessionId'];
    return stored?.toString().trim() ?? '';
  }
}
