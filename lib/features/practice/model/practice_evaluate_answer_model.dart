import 'practice_question_model.dart';
import 'practice_cues_guidance_model.dart';

class PracticeEvaluateAnswerRequest {
  final String audioPath;
  final int questionIndex;
  final String questionId;
  final String answerId;
  final String sessionId;
  final String characterId;
  final String panelName;
  final String challengeMode;
  final String mode;
  final int durationSeconds;
  final int sessionNumber;
  final String scenarioName;
  final String questionText;
  final String nextQuestionId;
  final String nextQuestionText;
  final bool isLastQuestion;
  final int totalQuestions;
  final int completedQuestions;
  final String userId;

  const PracticeEvaluateAnswerRequest({
    required this.audioPath,
    required this.questionIndex,
    required this.durationSeconds,
    this.questionId = '',
    this.answerId = '',
    this.sessionId = '',
    this.characterId = '',
    this.panelName = '',
    this.challengeMode = '',
    this.mode = '',
    this.sessionNumber = 0,
    this.scenarioName = '',
    this.questionText = '',
    this.nextQuestionId = '',
    this.nextQuestionText = '',
    this.isLastQuestion = false,
    this.totalQuestions = 3,
    this.completedQuestions = 0,
    this.userId = '',
  });

  Map<String, String> toFields() {
    final fields = <String, String>{
      'question_index': '$questionIndex',
      'duration_seconds': '$durationSeconds',
      'is_last_question': isLastQuestion ? 'true' : 'false',
      'total_questions': '$totalQuestions',
      'completed_questions': '$completedQuestions',
    };

    void put(String key, String value) {
      if (value.trim().isEmpty) return;
      fields[key] = value.trim();
    }

    put('question_id', questionId);
    put('answer_id', answerId);
    put('session_id', sessionId);
    put('character_id', characterId);
    put('panel_name', panelName);
    put('challenge_mode', challengeMode);
    put('mode', mode);
    put('scenario_name', scenarioName);
    put('question_text', questionText);
    put('next_question_id', nextQuestionId);
    put('next_question_text', nextQuestionText);
    put('user_id', userId);
    if (sessionNumber > 0) {
      fields['session_number'] = '$sessionNumber';
    }
    return fields;
  }
}

class PracticeEvaluateAnswerResult {
  final bool success;
  final int questionIndex;
  final String questionId;
  final String answerId;
  final String sessionId;
  final int sessionNumber;
  final String scenarioName;
  final String panelName;
  final String mode;
  final String userId;
  final String questionText;
  final int durationSeconds;
  final String durationFormatted;
  final String youSaid;
  final String whatLanded;
  final String forYourNextAnswer;
  final Map<String, double> dimensionsSummary;
  final double influenceScore;
  final PracticeQuestionModel? nextQuestion;
  final bool sessionComplete;

  const PracticeEvaluateAnswerResult({
    required this.success,
    required this.questionIndex,
    required this.questionId,
    required this.answerId,
    required this.sessionId,
    required this.sessionNumber,
    required this.scenarioName,
    required this.panelName,
    required this.mode,
    required this.userId,
    required this.questionText,
    required this.durationSeconds,
    required this.durationFormatted,
    required this.youSaid,
    required this.whatLanded,
    required this.forYourNextAnswer,
    required this.dimensionsSummary,
    required this.influenceScore,
    required this.sessionComplete,
    this.nextQuestion,
  });

  factory PracticeEvaluateAnswerResult.fromApi(Map<String, dynamic> json) {
    final payload = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final nextRaw = payload['next_question'];
    PracticeQuestionModel? nextQuestion;
    if (nextRaw is Map && nextRaw.isNotEmpty) {
      nextQuestion = _nextQuestionFromApi(Map<String, dynamic>.from(nextRaw));
    }

    final dimensions = <String, double>{};
    final dimsRaw = payload['dimensions_summary'];
    if (dimsRaw is Map) {
      dimsRaw.forEach((key, value) {
        if (value is num) dimensions[key.toString()] = value.toDouble();
      });
    }

    final apiIndex = _asInt(payload['question_index']);
    return PracticeEvaluateAnswerResult(
      success: payload['success'] != false,
      questionIndex: apiIndex <= 0 ? 1 : apiIndex,
      questionId: payload['question_id']?.toString() ?? '',
      answerId: payload['answer_id']?.toString() ?? '',
      sessionId: payload['session_id']?.toString() ?? '',
      sessionNumber: _asInt(payload['session_number']),
      scenarioName: payload['scenario_name']?.toString() ?? '',
      panelName: payload['panel_name']?.toString() ?? '',
      mode: payload['mode']?.toString() ?? '',
      userId: payload['user_id']?.toString() ?? '',
      questionText: payload['question_text']?.toString() ?? '',
      durationSeconds: _asInt(payload['duration_seconds']),
      durationFormatted: payload['duration_formatted']?.toString() ?? '',
      youSaid: payload['you_said']?.toString() ?? '',
      whatLanded: payload['what_landed']?.toString() ?? '',
      forYourNextAnswer: payload['for_your_next_answer']?.toString() ?? '',
      dimensionsSummary: dimensions,
      influenceScore: (payload['influence_score'] as num?)?.toDouble() ?? 0,
      sessionComplete: payload['session_complete'] == true,
      nextQuestion: nextQuestion,
    );
  }

  static PracticeQuestionModel? _nextQuestionFromApi(Map<String, dynamic> json) {
    final rawIndex = _asInt(json['index']);
    final questionIndex = rawIndex <= 0 ? 1 : rawIndex;
    final total = _asInt(json['total'], fallback: 3);
    final actions = (json['actions'] as Map?)?.cast<String, dynamic>() ?? {};
    final tips = json['guidance_tips'] as List? ?? [];

    const cueIcons = ['target', 'sound', 'clock', 'chat', 'heart'];

    return PracticeQuestionModel(
      stepTag: 'PRACTICE · QUESTION $questionIndex OF $total',
      questionIndex: questionIndex,
      totalQuestions: total > 0 ? total : 3,
      chips: const [],
      headline: json['coach_tip']?.toString() ?? '',
      coachContext: json['coach_tip']?.toString() ?? '',
      countsTag: '',
      speakerRole: json['roleplayer_tag']?.toString() ?? '',
      videoDuration: '',
      questionText: json['text']?.toString() ?? '',
      supportTip: json['coach_tip']?.toString() ?? '',
      yourMove: json['your_move']?.toString() ?? '',
      questionId: json['id']?.toString() ?? '',
      answerId: json['answer_id']?.toString() ?? '',
      roleplayerVideoUrl: json['roleplayer_video_url']?.toString(),
      roleplayerAudioUrl: json['roleplayer_audio_url']?.toString(),
      submitAnswerEndpoint: actions['submitAnswerEndpoint']?.toString() ?? '',
      tapToRecordLabel: actions['tapToRecord']?.toString() ?? 'Tap to record',
      hearQuestionAgainLabel:
          actions['hearQuestionAgain']?.toString() ?? 'Hear question again',
      cues: tips.whereType<Map>().toList().asMap().entries.map((entry) {
        final tip = Map<String, dynamic>.from(entry.value);
        return PracticePillarCueModel(
          title: tip['title']?.toString() ?? '',
          question: tip['description']?.toString() ??
              tip['question']?.toString() ??
              '',
          iconKey: cueIcons[entry.key % cueIcons.length],
        );
      }).toList(),
    );
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}
