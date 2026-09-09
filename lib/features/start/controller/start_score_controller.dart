import 'package:get/get.dart';
import '../model/influence_score_model.dart';

class StartScoreController extends GetxController {
  final RxInt startingInfluenceScore = 59.obs;
  final RxBool isLoading = false.obs;

  final List<TrainingPathInfo> trainingPathModules = const [
    TrainingPathInfo(
      pillar: 'GRAVITAS & TEMPO CONTROL',
      focus1: 'Slowing down pace by 15%',
      focus2: 'Eliminating upward inflections',
    ),
    TrainingPathInfo(
      pillar: 'STRATEGIC PAUSING',
      focus1: 'Using 2-second silence before answering',
      focus2: 'Zero filler words under pressure',
    ),
    TrainingPathInfo(
      pillar: 'HIGH-IMPACT STRUCTURING',
      focus1: 'Executive summary answers first',
      focus2: 'The 3-point persuasion formula',
    ),
  ];

  void finishOnboarding() {
    Get.snackbar(
      'Welcome to SpeechPro',
      'Your training session is starting!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
