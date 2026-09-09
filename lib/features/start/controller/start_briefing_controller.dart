import 'dart:async';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../model/briefing_model.dart';

class StartBriefingController extends GetxController {
  final RxInt briefingLoadingStage = 0.obs; // 0, 1, 2, 3 (Done)
  final RxBool isBriefingReady = false.obs;
  final RxBool isLoading = false.obs;

  // Briefing content (ready for API population)
  final Rx<PersonalBriefingModel> briefingData = const PersonalBriefingModel(
    goalTitle: 'JOB INTERVIEW',
    subGoal: 'Executive / Leadership Role',
    summary:
        'You\'re entering a high-stakes interview where authority, composure, and concise value articulation will decide the outcome.',
    pillars: [
      BriefingPillarModel(
        title: 'GRAVITAS & EXECUTIVE PRESENCE',
        body:
            'Lower your vocal pitch by 5-10% at sentence ends. Speak with measured cadence — 130-140 words per minute is optimal for conveying high seniority.',
      ),
      BriefingPillarModel(
        title: 'STRATEGIC PAUSING',
        body:
            'Replace filler words (um, uh, like) with 1-2 second intentional pauses. Senior leaders pause before answering difficult questions; it signals deep composure.',
      ),
      BriefingPillarModel(
        title: 'THE "PYRAMID PRINCIPLE" STRUCTURE',
        body:
            'Always state your conclusion or key achievement first, followed by the supporting rationale. Cut back-story by 40% to keep interviewers lean and engaged.',
      ),
    ],
    coachingNote:
        'Your SpeechPro training plan will focus on eliminating upward inflections, mastering the 2-second pause, and structuring high-impact responses under pressure.',
  ).obs;

  @override
  void onInit() {
    super.onInit();
    startBriefingGeneration();
  }

  void startBriefingGeneration() {
    isBriefingReady.value = false;
    briefingLoadingStage.value = 0;

    Future.delayed(const Duration(milliseconds: 900), () {
      briefingLoadingStage.value = 1;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      briefingLoadingStage.value = 2;
    });

    Future.delayed(const Duration(milliseconds: 2600), () {
      briefingLoadingStage.value = 3;
      isBriefingReady.value = true;
    });
  }

  void proceedToAssessment() {
    Get.toNamed(AppRoute.startStep3Assessment);
  }
}
