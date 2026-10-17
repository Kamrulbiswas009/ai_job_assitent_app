import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/logging/logger.dart';
import '../../start/controller/start_step2_details_controller.dart';
import '../model/practice_session_ready_model.dart';
import '../service/practice_session_service.dart';
import 'practice_coaching_brief_controller.dart';

class PracticeSessionReadyController extends GetxController {
  PracticeSessionReadyController({PracticeSessionService? sessionService})
      : _sessionService = sessionService ?? PracticeSessionService();

  final PracticeSessionService _sessionService;

  final Rx<PracticeSessionReadyModel> sessionData =
      PracticeSessionReadyModel.initial().obs;

  final RxString selectedRoleplayId = 'warm_hr'.obs;
  final RxString selectedChallengeModeId = 'challenge'.obs;
  final RxBool isPlayingFounderInsight = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isStartingSession = false.obs;
  final RxBool loadFailed = false.obs;

  RoleplayOptionModel? get selectedRoleplay {
    if (selectedRoleplayId.value.isEmpty) return null;
    try {
      return sessionData.value.roleplays.firstWhere(
        (r) => r.id == selectedRoleplayId.value,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
    final slug = _resolveScenarioSlug();
    StorageService.saveCurrentSession(
      route: AppRoute.practiceSessionReady,
      title: 'Practice Session Setup',
      scenarioSlug: slug,
    );
    fetchSessionPrepare();
  }

  Future<void> fetchSessionPrepare() async {
    isLoading.value = true;
    loadFailed.value = false;

    try {
      final scenarioSlug = _resolveScenarioSlug();
      final result =
          await _sessionService.fetchSessionPrepare(scenarioSlug);

      if (result != null) {
        sessionData.value = result;
        _applyDefaultSelections(result);
      } else {
        loadFailed.value = true;
        EasyLoading.showError(
          'Could not load session options. Showing defaults.',
        );
      }
    } catch (_) {
      loadFailed.value = true;
      EasyLoading.showError(
        'Could not load session options. Showing defaults.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _resolveScenarioSlug() {
    final args = Get.arguments;
    if (args is Map && args['scenarioSlug'] != null) {
      return args['scenarioSlug'].toString();
    }

    if (Get.isRegistered<StartStep2DetailsController>()) {
      return Get.find<StartStep2DetailsController>().selectedScenarioSlug.value;
    }

    return 'job_interview';
  }

  void _applyDefaultSelections(PracticeSessionReadyModel data) {
    if (data.roleplays.isNotEmpty) {
      final recommended = data.roleplays
          .where((roleplay) => roleplay.isRecommended)
          .firstOrNull;
      selectedRoleplayId.value =
          (recommended ?? data.roleplays.first).id;
    }

    if (data.challengeModes.isNotEmpty) {
      final challenge = data.challengeModes
          .where((mode) => mode.id == 'challenge')
          .firstOrNull;
      selectedChallengeModeId.value =
          (challenge ?? data.challengeModes.first).id;
    }
  }

  void selectRoleplay(String id) {
    if (selectedRoleplayId.value == id) {
      selectedRoleplayId.value = '';
    } else {
      selectedRoleplayId.value = id;
    }
  }

  void selectChallengeMode(String id) {
    selectedChallengeModeId.value = id;
  }

  void toggleFounderInsightVideo() {
    isPlayingFounderInsight.value = !isPlayingFounderInsight.value;
  }

  Future<void> onEnterSessionBrief() async {
    if (isStartingSession.value) return;

    if (selectedRoleplayId.value.isEmpty) {
      EasyLoading.showInfo('Please select a roleplay partner');
      return;
    }

    final roleplay = selectedRoleplay;
    if (roleplay == null) {
      EasyLoading.showInfo('Please select a roleplay partner');
      return;
    }

    isStartingSession.value = true;

    try {
      final scenarioSlug = _resolveScenarioSlug();
      final backendScenarioId =
          PracticeSessionService.toApiScenarioSlug(scenarioSlug);
      final aiScenarioId =
          PracticeSessionService.toAiScenarioId(scenarioSlug);
      final selectedMode = selectedChallengeModeId.value;
      final characterId = roleplay.characterId.isNotEmpty
          ? roleplay.characterId
          : RoleplayOptionModel.toCharacterId(roleplay.name);

      final startFuture = _sessionService.startSession(
        scenarioId: backendScenarioId,
        panelId: roleplay.id,
        mode: PracticeSessionService.toApiMode(selectedMode),
        missionId: backendScenarioId,
      );
      final briefFuture = _sessionService.fetchAiSessionBrief(
        scenarioId: aiScenarioId,
        characterId: characterId,
        description: _resolveSessionDescription(),
        challengeMode: selectedMode,
      );

      final backendSessionId = await startFuture;
      final aiBrief = await briefFuture;

      if (aiBrief == null) {
        EasyLoading.showError(
          'Could not load your session brief. Please try again.',
        );
        return;
      }

      if (Get.isRegistered<PracticeCoachingBriefController>()) {
        Get.find<PracticeCoachingBriefController>().applySessionBrief(
          aiBrief,
          backendSessionId: backendSessionId,
        );
      }

      await StorageService.saveCurrentSession(
        route: AppRoute.practiceCoachingBrief,
        title: 'Session Brief',
        scenarioSlug: scenarioSlug,
        arguments: {
          'backendSessionId': ?backendSessionId,
          'aiSessionId': aiBrief.sessionId,
        },
      );

      AppLoggerHelper.info(
        'Session brief ready. Backend session: ${backendSessionId ?? "none"}',
      );

      Get.toNamed(
        AppRoute.practiceCoachingBrief,
        arguments: {
          'brief': aiBrief,
          'backendSessionId': backendSessionId,
        },
      );
    } catch (e) {
      AppLoggerHelper.error('Failed to start session brief: $e', e);
      EasyLoading.showError(
        'Could not start this session. Please try again.',
      );
    } finally {
      isStartingSession.value = false;
    }
  }

  String _resolveSessionDescription() {
    if (Get.isRegistered<StartStep2DetailsController>()) {
      final details = Get.find<StartStep2DetailsController>();
      final voice = details.voiceAnswerTextController.text.trim();
      if (voice.isNotEmpty) return voice;
      final keywords = details.interviewKeywordsController.text.trim();
      if (keywords.isNotEmpty) return keywords;
      final role = details.roleApplyingController.text.trim();
      if (role.isNotEmpty) {
        return 'Practice a ${sessionData.value.missionTarget} for $role.';
      }
    }

    final sessionTarget = sessionData.value.sessionTarget?.trim();
    if (sessionTarget != null && sessionTarget.isNotEmpty) {
      return sessionTarget;
    }

    final quote = sessionData.value.missionTargetQuote.trim();
    if (quote.isNotEmpty) return quote;

    return 'Practice a ${sessionData.value.missionTarget} session.';
  }
}
