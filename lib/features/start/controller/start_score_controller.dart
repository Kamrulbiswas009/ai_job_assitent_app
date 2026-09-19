import 'dart:async';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/logging/logger.dart';
import '../model/influence_score_model.dart';
import '../service/assessment_service.dart';

class StartScoreController extends GetxController {
  final AssessmentService _assessmentService;

  StartScoreController({AssessmentService? assessmentService})
      : _assessmentService = assessmentService ?? AssessmentService();

  final RxBool isLoading = false.obs;
  final Rx<AssessmentResultResponse> scoreResult =
      AssessmentResultResponse.fallback.obs;

  // Polling configuration
  static const int _maxRetries = 10;
  static const Duration _retryDelay = Duration(seconds: 3);

  int get startingInfluenceScore => scoreResult.value.influenceScore;
  DimensionScores get dimensions => scoreResult.value.dimensions;
  AssessmentInterpretation get interpretation => scoreResult.value.interpretation;
  TrainingPath get trainingPath => scoreResult.value.trainingPath;

  @override
  void onInit() {
    super.onInit();
    fetchResult();
  }

  /// Fetches the Influence Score and full result from GET /api/v1/assessment/{assessment_id}/result.
  /// Polls up to [_maxRetries] times with [_retryDelay] between attempts to handle
  /// the backend race condition where the assessment is still processing after voice upload.
  Future<void> fetchResult() async {
    final assessmentId = StorageService.assessmentId ?? '';
    if (assessmentId.isEmpty) {
      AppLoggerHelper.warning(
        'No assessmentId found in storage for fetching results. Using fallback.',
      );
      return;
    }

    isLoading.value = true;
    try {
      for (int attempt = 1; attempt <= _maxRetries; attempt++) {
        AppLoggerHelper.info(
          'Fetching assessment result (attempt $attempt/$_maxRetries)...',
        );

        final result = await _assessmentService.fetchAssessmentResult(assessmentId);

        if (result != null) {
          scoreResult.value = result;
          AppLoggerHelper.info(
            'Successfully loaded Influence Score: ${result.influenceScore} '
            'and 6 dimensions on attempt $attempt.',
          );
          return;
        }

        if (attempt < _maxRetries) {
          AppLoggerHelper.warning(
            'Assessment not ready yet (attempt $attempt/$_maxRetries). '
            'Retrying in ${_retryDelay.inSeconds}s...',
          );
          await Future.delayed(_retryDelay);
        }
      }

      AppLoggerHelper.warning(
        'Assessment result still not ready after $_maxRetries attempts. '
        'Displaying baseline fallback.',
      );
    } catch (e) {
      AppLoggerHelper.error('Error fetching assessment result: $e', e);
    } finally {
      isLoading.value = false;
    }
  }

  void finishOnboarding() {
    if (Get.context != null) {
      Get.snackbar(
        'Welcome to SpeechPro',
        'Your training session is starting!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
