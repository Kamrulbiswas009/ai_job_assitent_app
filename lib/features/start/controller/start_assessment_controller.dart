import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/logging/logger.dart';
import '../../../../routes/app_routes.dart';
import '../model/benchmark_model.dart';
import '../service/assessment_service.dart';

class StartAssessmentController extends GetxController {
  final AssessmentService _assessmentService;

  StartAssessmentController({AssessmentService? assessmentService})
      : _assessmentService = assessmentService ?? AssessmentService();

  final RxBool isLoading = false.obs;
  final RxString assessmentId = ''.obs;

  static const List<String> _optionSlugs = [
    'rarely',
    'sometimes',
    'often',
    'usually',
    'always',
  ];

  final RxList<BenchmarkQuestionModel> benchmarkQuestions =
      <BenchmarkQuestionModel>[
    BenchmarkQuestionModel(
      id: 'q1',
      title: 'When speaking to a group or presenting, I feel confident',
      selectedIndex: null,
    ),
    BenchmarkQuestionModel(
      id: 'q2',
      title: 'I communicate with authority — people listen when I speak',
      selectedIndex: null,
    ),
    BenchmarkQuestionModel(
      id: 'q3',
      title: 'People respond positively to how I communicate in key situations',
      selectedIndex: null,
    ),
  ].obs;

  bool get isAllAnswered =>
      benchmarkQuestions.isNotEmpty &&
      benchmarkQuestions.every((q) => q.selectedIndex != null);

  void setBenchmarkAnswer(int questionIndex, int optionIndex) {
    benchmarkQuestions[questionIndex].selectedIndex = optionIndex;
    benchmarkQuestions.refresh();
  }

  String _indexToSlug(int? index) {
    if (index != null && index >= 0 && index < _optionSlugs.length) {
      return _optionSlugs[index];
    }
    return 'rarely';
  }

  Future<void> submitAssessmentAndProceed() async {
    // Verify all questions are answered
    for (int i = 0; i < benchmarkQuestions.length; i++) {
      if (benchmarkQuestions[i].selectedIndex == null) {
        try {
          EasyLoading.showInfo(
            'Please answer question ${i + 1} before proceeding.',
          ).catchError((_) {});
        } catch (_) {}
        return;
      }
    }

    isLoading.value = true;

    try {
      final request = SelfAssessmentRequest(
        confidence: _indexToSlug(benchmarkQuestions[0].selectedIndex),
        authority: _indexToSlug(benchmarkQuestions[1].selectedIndex),
        communication: _indexToSlug(benchmarkQuestions[2].selectedIndex),
      );

      final response = await _assessmentService.submitSelfAssessment(request);

      if (response != null && response.success && response.data != null) {
        final id = response.data!.assessmentId;
        assessmentId.value = id;
        await StorageService.saveAssessmentId(id);
        AppLoggerHelper.info(
          'Self-assessment created successfully with assessment_id: $id. Proceeding to calibration.',
        );

        Get.toNamed(AppRoute.startStep4Calibration);
      } else {
        // Handle server offline or API error gracefully with fallback session ID so the onboarding flow is not blocked
        final fallbackId =
            'fallback_${DateTime.now().millisecondsSinceEpoch}';
        assessmentId.value = fallbackId;
        await StorageService.saveAssessmentId(fallbackId);

        final message = response?.message ??
            'AI assessment server is temporarily offline. Proceeding with offline calibration.';
        AppLoggerHelper.warning(
          'Self-assessment API returned error ($message). Proceeding with fallback assessment_id: $fallbackId',
        );

        Get.toNamed(AppRoute.startStep4Calibration);
      }
    } catch (e) {
      AppLoggerHelper.error(
        'Unexpected error during self-assessment submission: $e',
        e,
      );

      final fallbackId =
          'fallback_${DateTime.now().millisecondsSinceEpoch}';
      assessmentId.value = fallbackId;
      await StorageService.saveAssessmentId(fallbackId);

      Get.toNamed(AppRoute.startStep4Calibration);
    } finally {
      isLoading.value = false;
    }
  }
}
