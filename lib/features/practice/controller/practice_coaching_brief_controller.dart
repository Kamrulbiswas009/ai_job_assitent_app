import 'package:get/get.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_coaching_brief_model.dart';

class PracticeCoachingBriefController extends GetxController {
  final Rx<PracticeCoachingBriefModel> briefData =
      PracticeCoachingBriefModel.initial().obs;

  final RxBool isPlayingBriefVideo = false.obs;
  final RxBool isDoctrineExpanded = false.obs;

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
