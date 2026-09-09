import 'package:get/get.dart';
import '../../features/onboarding/controller/onboarding_controller.dart';
import '../../features/start/controller/start_assessment_controller.dart';
import '../../features/start/controller/start_briefing_controller.dart';
import '../../features/start/controller/start_calibration_controller.dart';
import '../../features/start/controller/start_controller.dart';
import '../../features/start/controller/start_goals_controller.dart';
import '../../features/start/controller/start_membership_controller.dart';
import '../../features/start/controller/start_score_controller.dart';
import '../../features/start/controller/start_step2_details_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
    Get.lazyPut<StartMembershipController>(
      () => StartMembershipController(),
      fenix: true,
    );
    Get.lazyPut<StartGoalsController>(
      () => StartGoalsController(),
      fenix: true,
    );
    Get.lazyPut<StartStep2DetailsController>(
      () => StartStep2DetailsController(),
      fenix: true,
    );
    Get.lazyPut<StartBriefingController>(
      () => StartBriefingController(),
      fenix: true,
    );
    Get.lazyPut<StartAssessmentController>(
      () => StartAssessmentController(),
      fenix: true,
    );
    Get.lazyPut<StartCalibrationController>(
      () => StartCalibrationController(),
      fenix: true,
    );
    Get.lazyPut<StartScoreController>(
      () => StartScoreController(),
      fenix: true,
    );
    Get.lazyPut<StartController>(
      () => StartController(),
      fenix: true,
    );
  }
}