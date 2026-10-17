import 'package:flutter_test/flutter_test.dart';
import 'package:studioequip_mobile_app/features/practice/model/practice_coach_feedback_model.dart';
import 'package:studioequip_mobile_app/features/practice/model/practice_evaluate_answer_model.dart';

void main() {
  test('PracticeEvaluateAnswerResult maps swagger evaluate-answer payload', () {
    final result = PracticeEvaluateAnswerResult.fromApi({
      'success': true,
      'question_index': 1,
      'question_id': 'q-1',
      'answer_id': 'a-1',
      'session_id': 's-1',
      'session_number': 2,
      'scenario_name': 'Job Interview',
      'panel_name': 'Warm HR Partner',
      'mode': 'CHALLENGE',
      'user_id': 'u-1',
      'question_text': 'Tell me about a difficult decision.',
      'duration_seconds': 12,
      'duration_formatted': '0:12',
      'you_said': 'I chose the longer path for the team.',
      'what_landed': 'Clear ownership and calm delivery.',
      'for_your_next_answer': 'Name the outcome and what you learned.',
      'dimensions_summary': {'clarity': 8, 'presence': 7},
      'influence_score': 72,
      'next_question': {
        'index': 2,
        'id': 'q-2',
        'answer_id': 'a-2',
        'total': 3,
        'text': 'How did the team respond?',
        'coach_tip': 'Bring people into the story.',
        'your_move': 'Show the human impact.',
        'roleplayer_tag': 'Warm HR Partner Ask:',
        'guidance_tips': [
          {'title': 'Focused Entry', 'description': 'Feed the whole room.'},
        ],
        'actions': {'tapToRecord': 'Tap to record'},
      },
      'session_complete': false,
    });

    expect(result.success, isTrue);
    expect(result.questionIndex, 1); // 0-based fallback stays question 1
    expect(result.youSaid, 'I chose the longer path for the team.');
    expect(result.whatLanded, 'Clear ownership and calm delivery.');
    expect(result.forYourNextAnswer, 'Name the outcome and what you learned.');
    expect(result.durationFormatted, '0:12');
    expect(result.influenceScore, 72);
    expect(result.sessionComplete, isFalse);
    expect(result.nextQuestion, isNotNull);
    expect(result.nextQuestion!.questionIndex, 2);
    expect(result.nextQuestion!.questionText, 'How did the team respond?');
    expect(result.nextQuestion!.cues, isNotEmpty);

    final feedback = PracticeCoachFeedbackModel.fromEvaluate(
      result: result,
      questionIndex: 1,
      totalQuestions: 3,
      durationLabel: '0:12',
      audioPath: '/tmp/answer.m4a',
    );
    expect(feedback.youSaid, 'I chose the longer path for the team.');
    expect(feedback.hasNextQuestion, isTrue);
    expect(feedback.nextQuestionIndex, 2);
  });

  test('Evaluate request omits empty optional fields', () {
    const request = PracticeEvaluateAnswerRequest(
      audioPath: '/tmp/answer.m4a',
      questionIndex: 0,
      durationSeconds: 12,
      questionText: 'Tell me about a difficult decision.',
      isLastQuestion: false,
      totalQuestions: 3,
    );

    final fields = request.toFields();
    expect(fields['question_index'], '0');
    expect(fields['duration_seconds'], '12');
    expect(fields['question_text'], 'Tell me about a difficult decision.');
    expect(fields.containsKey('session_id'), isFalse);
    expect(fields.containsKey('user_id'), isFalse);
  });
}
