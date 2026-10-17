import 'package:get/get.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../model/practice_coaching_brief_model.dart';

class PracticeCoachingBriefController extends GetxController {
  final Rx<PracticeCoachingBriefModel> briefData =
      PracticeCoachingBriefModel.initial().obs;

  final RxBool isPlayingBriefVideo = false.obs;
  final RxBool isDoctrineExpanded = false.obs;
  final RxString backendSessionId = ''.obs;
  final RxString aiSessionId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    applyArguments(Get.arguments);
    StorageService.saveCurrentSession(
      route: AppRoute.practiceCoachingBrief,
      title: 'Session Brief',
    );
  }

  void applyArguments(dynamic args) {
    if (args is! Map) return;

    final brief = args['brief'];
    if (brief is PracticeCoachingBriefModel) {
      applySessionBrief(
        brief,
        backendSessionId: args['backendSessionId'] as String?,
      );
    }
  }

  void applySessionBrief(
    PracticeCoachingBriefModel brief, {
    String? backendSessionId,
  }) {
    briefData.value = brief;
    aiSessionId.value = brief.sessionId;
    if (backendSessionId != null && backendSessionId.isNotEmpty) {
      this.backendSessionId.value = backendSessionId;
    }
  }

  void toggleBriefVideo() {
    isPlayingBriefVideo.value = !isPlayingBriefVideo.value;
  }

  void toggleDoctrine() {
    isDoctrineExpanded.value = !isDoctrineExpanded.value;
  }

  void onBeginPractice() {
    Get.toNamed(AppRoute.practiceWarmup);
  }
}
