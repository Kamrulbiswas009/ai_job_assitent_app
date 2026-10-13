import 'package:get/get.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_session_ready_model.dart';

class PracticeSessionReadyController extends GetxController {
  final Rx<PracticeSessionReadyModel> sessionData =
      PracticeSessionReadyModel.initial().obs;

  final RxString selectedRoleplayId = 'warm_hr'.obs;
  final RxString selectedChallengeModeId = 'challenge'.obs;
  final RxBool isPlayingFounderInsight = false.obs;

  RoleplayOptionModel? get selectedRoleplay {
    try {
      return sessionData.value.roleplays.firstWhere(
        (r) => r.id == selectedRoleplayId.value,
      );
    } catch (_) {
      return sessionData.value.roleplays.firstOrNull;
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
