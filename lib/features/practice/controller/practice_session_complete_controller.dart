import 'package:get/get.dart';
import 'package:studioequip_mobile_app/core/services/storage_service.dart';
import 'package:studioequip_mobile_app/routes/app_routes.dart';
import '../model/practice_session_complete_model.dart';
import 'practice_question_controller.dart';
import 'practice_session_ready_controller.dart';

class PracticeSessionCompleteController extends GetxController {
  final Rx<PracticeSessionCompleteModel> data =
      PracticeSessionCompleteModel.initial().obs;

  @override
  void onInit() {
    super.onInit();
    data.value = _resolveSession();
    StorageService.saveCurrentSession(
      route: AppRoute.practiceSessionComplete,
      title: data.value.sessionTitle,
    );
  }

  PracticeSessionCompleteModel _resolveSession() {
    var sessionNumber = 1;
    var scenario = 'Job Interview';
    var panel = 'Warm HR Partner';

    if (Get.isRegistered<PracticeQuestionController>()) {
      final question = Get.find<PracticeQuestionController>();
      if (question.sessionNumber.value > 0) {
        sessionNumber = question.sessionNumber.value;
      }
      if (question.scenarioName.value.trim().isNotEmpty) {
        scenario = question.scenarioName.value.trim();
      }
      if (question.panelName.value.trim().isNotEmpty) {
        panel = question.panelName.value.trim();
      }
    }

    if (Get.isRegistered<PracticeSessionReadyController>()) {
      final readyController = Get.find<PracticeSessionReadyController>();
      final ready = readyController.sessionData.value;
      if (ready.missionTarget.trim().isNotEmpty) {
        scenario = ready.missionTarget.trim();
      }
      final selected = readyController.selectedRoleplay?.name;
      if (selected != null && selected.trim().isNotEmpty) {
        panel = selected.trim();
      }
    }

    return PracticeSessionCompleteModel(
      sessionNumber: sessionNumber,
      scenarioName: scenario,
      panelName: panel,
    );
  }

  void continueToProgression() {
    Get.toNamed(AppRoute.practiceSessionProgression, arguments: data.value);
  }
}
