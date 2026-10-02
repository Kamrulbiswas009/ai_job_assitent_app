import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../model/goal_model.dart';

import 'start_membership_controller.dart';
import 'start_step2_details_controller.dart';

class StartGoalsController extends GetxController {
  final RxString userName = 'Aycan Doganlar'.obs;
  final RxString selectedGoalId = '01'.obs;
  final RxString selectedGoalTitle = 'Job Interview'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final storedName = StorageService.fullName;
    if (storedName != null && storedName.trim().isNotEmpty) {
      userName.value = storedName.trim();
    } else if (Get.isRegistered<StartMembershipController>() &&
        Get.find<StartMembershipController>().userName.value.trim().isNotEmpty) {
      userName.value =
          Get.find<StartMembershipController>().userName.value.trim();
    }
  }

  final List<GoalCategoryModel> goalCategories = [
    const GoalCategoryModel(id: '01', number: '01', title: 'Job Interview'),
    const GoalCategoryModel(id: '02', number: '02', title: 'Investor Pitch'),
    const GoalCategoryModel(id: '03', number: '03', title: 'Promotion or Pay Rise'),
    const GoalCategoryModel(id: '04', number: '04', title: 'TED Talk or Presentation'),
    const GoalCategoryModel(id: '05', number: '05', title: 'Sales or Client Meeting'),
    const GoalCategoryModel(id: '06', number: '06', title: 'Podcast or Camera'),
    const GoalCategoryModel(id: '07', number: '07', title: 'Social Confidence'),
    const GoalCategoryModel(id: '08', number: '08', title: 'English and Pronunciation'),
    const GoalCategoryModel(id: '09', number: '09', title: 'Difficult Conversation'),
    const GoalCategoryModel(id: '10', number: '10', title: 'Negotiation'),
    const GoalCategoryModel(id: '11', number: '11', title: 'Leading a Team'),
    const GoalCategoryModel(id: '12', number: '12', title: 'Board or Executive Meeting'),
    const GoalCategoryModel(id: '13', number: '13', title: 'TV, Radio or Press'),
    const GoalCategoryModel(id: '14', number: '14', title: 'Wedding Speech or Toast'),
    const GoalCategoryModel(id: '15', number: '15', title: 'Training or Teaching'),
    const GoalCategoryModel(id: '16', number: '16', title: 'Virtual and Zoom Presence'),
    const GoalCategoryModel(id: '17', number: '17', title: 'Overcoming Speaking Anxiety'),
    const GoalCategoryModel(id: '18', number: '18', title: 'Something Else'),
  ];

  void selectGoal(GoalCategoryModel goal) {
    selectedGoalId.value = goal.id;
    selectedGoalTitle.value = goal.title;
  }

  void submitGoalAndProceed() {
    if (Get.isRegistered<StartStep2DetailsController>()) {
      Get.find<StartStep2DetailsController>().syncScenario(
        id: selectedGoalId.value,
        title: selectedGoalTitle.value,
      );
    }
    Get.toNamed(AppRoute.startStep2Details);
  }
}
