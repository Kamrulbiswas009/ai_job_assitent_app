import 'dart:async';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../model/briefing_model.dart';

class StartBriefingController extends GetxController {
  final RxDouble progressPercent = 1.0.obs;
  final RxInt briefingLoadingStage = 3.obs; // 0, 1, 2, 3 (Done)
  final RxBool isBriefingReady = true.obs;
  final RxBool showBlackPopup = false.obs;
  final RxBool isLoading = false.obs;
  final RxString userFirstName = 'Aycan'.obs;
  final RxString scenarioTitle = 'Job Interview'.obs;
  Timer? _progressTimer;

  // Briefing content (dynamically populated from API)
  final Rx<PersonalBriefingModel> briefingData =
      PersonalBriefingModel.fallback.obs;

  @override
  void onClose() {
    _progressTimer?.cancel();
    super.onClose();
  }

  void setBriefingData(
    PersonalBriefingModel data, {
    String? firstName,
    String? scenario,
  }) {
    briefingData.value = data;
    if (firstName != null && firstName.trim().isNotEmpty) {
      final trimmed = firstName.trim();
      final capitalized = trimmed
          .split(RegExp(r'\s+'))
          .map((w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1)}'
              : '')
          .join(' ');
      userFirstName.value = capitalized;
    }
    if (scenario != null && scenario.isNotEmpty) {
      scenarioTitle.value = scenario;
    }
  }

  void startBriefingGeneration() {
    isBriefingReady.value = false;
    showBlackPopup.value = true;
    briefingLoadingStage.value = 0;
    progressPercent.value = 0.0;

    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
      if (progressPercent.value < 0.33) {
        progressPercent.value += 0.015;
        briefingLoadingStage.value = 0;
      } else if (progressPercent.value < 0.66) {
        progressPercent.value += 0.012;
        briefingLoadingStage.value = 1;
      } else if (progressPercent.value < 1.0) {
        progressPercent.value += 0.012;
        briefingLoadingStage.value = 2;
      } else {
        progressPercent.value = 1.0;
        briefingLoadingStage.value = 3;
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 700), () {
          showBlackPopup.value = false;
          isBriefingReady.value = true;
        });
      }
    });
  }

  void dismissBlackPopup() {
    showBlackPopup.value = false;
  }

  void proceedToAssessment() {
    Get.toNamed(AppRoute.startStep3Assessment);
  }
}
