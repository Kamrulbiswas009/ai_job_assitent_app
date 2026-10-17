import 'practice_evaluate_answer_model.dart';
import 'practice_question_model.dart';

class PracticeCoachFeedbackModel {
  final int questionIndex;
  final int totalQuestions;
  final String youSaid;
  final String durationLabel;
  final String whatLanded;
  final String nextAnswerTip;
  final String audioPath;
  final bool sessionComplete;
  final PracticeQuestionModel? nextQuestion;

  const PracticeCoachFeedbackModel({
    required this.questionIndex,
    required this.totalQuestions,
    required this.youSaid,
    required this.durationLabel,
    required this.whatLanded,
    required this.nextAnswerTip,
    this.audioPath = '',
    this.sessionComplete = false,
    this.nextQuestion,
  });

  bool get hasNextQuestion =>
      !sessionComplete && questionIndex < totalQuestions;

  int get nextQuestionIndex => questionIndex + 1;

  factory PracticeCoachFeedbackModel.forQuestion({
    required int questionIndex,
    required int totalQuestions,
    required String durationLabel,
    String audioPath = '',
    String? youSaid,
    String? whatLanded,
    String? nextAnswerTip,
    bool sessionComplete = false,
    PracticeQuestionModel? nextQuestion,
  }) {
    return PracticeCoachFeedbackModel(
      questionIndex: questionIndex,
      totalQuestions: totalQuestions,
      durationLabel: durationLabel,
      audioPath: audioPath,
      sessionComplete: sessionComplete,
      nextQuestion: nextQuestion,
      youSaid: youSaid?.trim().isNotEmpty == true
          ? youSaid!.trim()
          : 'I decided to move forward with the project because I knew it would create long-term value for the team and the company.',
      whatLanded: whatLanded?.trim().isNotEmpty == true
          ? whatLanded!.trim()
          : 'You showed clear thinking, ownership and a focus on the bigger picture. It felt confident and authentic.',
      nextAnswerTip: nextAnswerTip?.trim().isNotEmpty == true
          ? nextAnswerTip!.trim()
          : 'Try to be a bit more specific with the outcome and what you learned from the decision.',
    );
  }

  factory PracticeCoachFeedbackModel.fromEvaluate({
    required PracticeEvaluateAnswerResult result,
    required int questionIndex,
    required int totalQuestions,
    required String durationLabel,
    required String audioPath,
  }) {
    return PracticeCoachFeedbackModel.forQuestion(
      questionIndex: questionIndex,
      totalQuestions: result.nextQuestion?.totalQuestions ?? totalQuestions,
      durationLabel: result.durationFormatted.trim().isNotEmpty
          ? result.durationFormatted.trim()
          : durationLabel,
      audioPath: audioPath,
      youSaid: result.youSaid,
      whatLanded: result.whatLanded,
      nextAnswerTip: result.forYourNextAnswer,
      sessionComplete: result.sessionComplete,
      nextQuestion: result.nextQuestion,
    );
  }
}
