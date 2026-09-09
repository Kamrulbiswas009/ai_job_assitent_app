import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../model/benchmark_model.dart';

class StartAssessmentController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxList<BenchmarkQuestionModel> benchmarkQuestions =
      <BenchmarkQuestionModel>[
    BenchmarkQuestionModel(
      id: 'q1',
      title: 'When speaking to a group or presenting, I feel confident',
      selectedIndex: 1, // Sometimes
    ),
    BenchmarkQuestionModel(
      id: 'q2',
      title: 'I communicate with authority — people listen when I speak',
      selectedIndex: 0, // Rarely
    ),
    BenchmarkQuestionModel(
      id: 'q3',
      title: 'People respond positively to how I communicate in key situations',
      selectedIndex: 0, // Rarely
    ),
  ].obs;

  void setBenchmarkAnswer(int questionIndex, int optionIndex) {
    benchmarkQuestions[questionIndex].selectedIndex = optionIndex;
    benchmarkQuestions.refresh();
  }

  void submitAssessmentAndProceed() {
    Get.toNamed(AppRoute.startStep4Calibration);
  }
}
