import 'package:get/get.dart';
import '../../features/onboarding/controller/onboarding_controller.dart';
import '../../features/start/controller/start_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
    Get.lazyPut<StartController>(
      () => StartController(),
      fenix: true,
    );
  }
}