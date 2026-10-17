import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_session_complete_model.dart';

class PracticeSessionProgressionController extends GetxController {
  final Rx<PracticeSessionCompleteModel> session =
      PracticeSessionCompleteModel.initial().obs;
  final Rx<PracticeSessionProgressionModel> progression =
      PracticeSessionProgressionModel.initial().obs;

  int get nextSessionNumber => session.value.sessionNumber + 1;

  String get continueLabel =>
      'Continue to Session $nextSessionNumber: ${progression.value.nextSession.title}  →';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is PracticeSessionCompleteModel) {
      session.value = Get.arguments as PracticeSessionCompleteModel;
    }
    progression.value = PracticeSessionProgressionModel.initial(
      nextSessionNumber: nextSessionNumber,
    );
    StorageService.saveCurrentSession(
      route: AppRoute.practiceSessionProgression,
      title: 'Your Progression',
    );
  }

  void recapDoctrine() {
    EasyLoading.showToast('Opening ${progression.value.doctrine.title} recap…');
  }

  void recapModule() {
    EasyLoading.showToast(
      'Opening ${progression.value.curriculum.title} recap…',
    );
  }

  void openChapterAction(PracticeChapterAction action) {
    EasyLoading.showToast(action.label);
  }

  void continueToNextSession() {
    Get.offAllNamed(AppRoute.practiceSessionReady);
  }

  void returnHome() {
    Get.offAllNamed(AppRoute.practiceSessionReady);
  }
}
