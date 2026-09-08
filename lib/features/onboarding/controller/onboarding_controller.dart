import 'dart:async';
import 'package:get/get.dart';
import '../model/membership_plan_model.dart';

class OnboardingController extends GetxController {
  final RxInt selectedPlanIndex = 0.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxInt resendCountdown = 30.obs;
  Timer? _timer;

  final RxList<MembershipPlanModel> plans = <MembershipPlanModel>[
    const MembershipPlanModel(
      id: 'monthly',
      title: 'Monthly Access',
      price: '£39',
      period: '/month',
      isPopular: false,
    ),
    const MembershipPlanModel(
      id: 'annual',
      title: 'Annual Access',
      price: '£299',
      period: '/year',
      badge: 'SAVE 36%',
      isPopular: true,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    startResendTimer();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  void startResendTimer() {
    _timer?.cancel();
    resendCountdown.value = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendCountdown.value > 0) {
        resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
