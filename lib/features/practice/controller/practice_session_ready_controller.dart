import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../../start/controller/start_step2_details_controller.dart';
import '../model/practice_session_ready_model.dart';
import '../service/practice_session_service.dart';

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
  final RxBool loadFailed = false.obs;

  RoleplayOptionModel? get selectedRoleplay {
    try {
      return sessionData.value.roleplays.firstWhere(
        (r) => r.id == selectedRoleplayId.value,
      );
    } catch (_) {
      return sessionData.value.roleplays.firstOrNull;
    }
  }

  @override
  void onInit() {
    super.onInit();
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
    selectedRoleplayId.value = id;
  }

  void selectChallengeMode(String id) {
    selectedChallengeModeId.value = id;
  }

  void toggleFounderInsightVideo() {
    isPlayingFounderInsight.value = !isPlayingFounderInsight.value;
  }

  void onEnterSessionBrief() {
    Get.toNamed(AppRoute.practiceCoachingBrief);
  }
}
