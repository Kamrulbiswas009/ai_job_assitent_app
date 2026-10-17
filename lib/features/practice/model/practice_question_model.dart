import 'practice_cues_guidance_model.dart';

class PracticeSessionQuestionsResult {
  final String sessionId;
  final int sessionNumber;
  final String scenarioName;
  final String panelName;
  final String mode;
  final int totalQuestions;
  final int completedQuestions;
  final List<PracticeQuestionModel> questions;

  const PracticeSessionQuestionsResult({
    required this.sessionId,
    required this.sessionNumber,
    required this.scenarioName,
    required this.panelName,
    required this.mode,
    required this.totalQuestions,
    required this.completedQuestions,
    required this.questions,
  });

  factory PracticeSessionQuestionsResult.fromApi(Map<String, dynamic> json) {
    final questions = (json['questions'] as List? ?? [])
        .whereType<Map>()
        .map(
          (item) => PracticeQuestionModel.fromSessionApi(
            session: json,
            question: Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    return PracticeSessionQuestionsResult(
      sessionId: json['sessionId'] as String? ?? '',
      sessionNumber: json['sessionNumber'] as int? ?? 0,
      scenarioName: json['scenarioName'] as String? ?? '',
      panelName: json['panelName'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      totalQuestions: json['totalQuestions'] as int? ?? questions.length,
      completedQuestions: json['completedQuestions'] as int? ?? 0,
      questions: questions,
    );
  }
}

class PracticeQuestionModel {
  final String stepTag;
  final int questionIndex;
  final int totalQuestions;
  final List<String> chips;
  final String headline;
  final String coachContext;
  final String countsTag;
  final String speakerRole;
  final String videoDuration;
  final String questionText;
  final String supportTip;
  final String yourMove;
  final String thumbnailAsset;
  final String? thumbnailUrl;
  final String? roleplayerVideoUrl;
  final String? roleplayerAudioUrl;
  final String questionId;
  final String answerId;
  final String submitAnswerEndpoint;
  final String tapToRecordLabel;
  final String hearQuestionAgainLabel;
  final List<PracticePillarCueModel> cues;

  const PracticeQuestionModel({
    required this.stepTag,
    required this.chips,
    required this.headline,
    required this.coachContext,
    required this.countsTag,
    required this.speakerRole,
    required this.videoDuration,
    required this.questionText,
    required this.supportTip,
    required this.yourMove,
    this.questionIndex = 1,
    this.totalQuestions = 3,
    this.thumbnailAsset = '',
    this.thumbnailUrl,
    this.roleplayerVideoUrl,
    this.roleplayerAudioUrl,
    this.questionId = '',
    this.answerId = '',
    this.submitAnswerEndpoint = '',
    this.tapToRecordLabel = 'Tap to record',
    this.hearQuestionAgainLabel = 'Hear question again',
    this.cues = const [],
  });

  double get progressFraction {
    if (totalQuestions <= 0) return 0;
    return (questionIndex / totalQuestions).clamp(0.0, 1.0);
  }

  PracticeQuestionModel copyWith({
    String? stepTag,
    int? questionIndex,
    int? totalQuestions,
    List<String>? chips,
    String? headline,
    String? coachContext,
    String? countsTag,
    String? speakerRole,
    String? videoDuration,
    String? questionText,
    String? supportTip,
    String? yourMove,
    String? thumbnailAsset,
    String? thumbnailUrl,
    String? roleplayerVideoUrl,
    String? roleplayerAudioUrl,
    String? questionId,
    String? answerId,
    String? submitAnswerEndpoint,
    String? tapToRecordLabel,
    String? hearQuestionAgainLabel,
    List<PracticePillarCueModel>? cues,
  }) {
    return PracticeQuestionModel(
      stepTag: stepTag ?? this.stepTag,
      questionIndex: questionIndex ?? this.questionIndex,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      chips: chips ?? this.chips,
      headline: headline ?? this.headline,
      coachContext: coachContext ?? this.coachContext,
      countsTag: countsTag ?? this.countsTag,
      speakerRole: speakerRole ?? this.speakerRole,
      videoDuration: videoDuration ?? this.videoDuration,
      questionText: questionText ?? this.questionText,
      supportTip: supportTip ?? this.supportTip,
      yourMove: yourMove ?? this.yourMove,
      thumbnailAsset: thumbnailAsset ?? this.thumbnailAsset,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      roleplayerVideoUrl: roleplayerVideoUrl ?? this.roleplayerVideoUrl,
      roleplayerAudioUrl: roleplayerAudioUrl ?? this.roleplayerAudioUrl,
      questionId: questionId ?? this.questionId,
      answerId: answerId ?? this.answerId,
      submitAnswerEndpoint: submitAnswerEndpoint ?? this.submitAnswerEndpoint,
      tapToRecordLabel: tapToRecordLabel ?? this.tapToRecordLabel,
      hearQuestionAgainLabel:
          hearQuestionAgainLabel ?? this.hearQuestionAgainLabel,
      cues: cues ?? this.cues,
    );
  }

  factory PracticeQuestionModel.fromSessionApi({
    required Map<String, dynamic> session,
    required Map<String, dynamic> question,
  }) {
    final index = question['questionIndex'] as int? ?? 1;
    final total = session['totalQuestions'] as int? ?? 3;
    final mode = (session['mode'] as String? ?? '').trim().toUpperCase();
    final modeLabel = mode == 'CHALLENGE' ? 'Challenge Mode' : 'Standard Mode';
    final before =
        (question['beforeYouAnswer'] as Map?)?.cast<String, dynamic>() ?? {};
    final actions =
        (question['actions'] as Map?)?.cast<String, dynamic>() ?? {};
    final tips = question['guidanceTips'] as List? ?? [];

    const cueIcons = ['target', 'sound', 'clock', 'chat', 'heart'];

    return PracticeQuestionModel(
      stepTag: 'PRACTICE · QUESTION $index OF $total',
      questionIndex: index,
      totalQuestions: total,
      chips: [
        if ((session['scenarioName'] as String?)?.trim().isNotEmpty == true)
          session['scenarioName'].toString().trim(),
        if ((session['panelName'] as String?)?.trim().isNotEmpty == true)
          session['panelName'].toString().trim(),
        modeLabel,
      ],
      headline: question['coachPromptTitle'] as String? ?? '',
      coachContext: question['coachPromptBody'] as String? ?? '',
      countsTag: '',
      speakerRole: question['roleplayerTag'] as String? ?? '',
      videoDuration: '',
      questionText: question['questionText'] as String? ?? '',
      supportTip: before['supportNote'] as String? ?? '',
      yourMove: before['yourMove'] as String? ?? '',
      roleplayerVideoUrl: question['roleplayerVideoUrl'] as String?,
      roleplayerAudioUrl: question['roleplayerAudioUrl'] as String?,
      questionId: question['questionId']?.toString() ??
          question['id']?.toString() ??
          '',
      answerId: question['answerId'] as String? ?? '',
      submitAnswerEndpoint: actions['submitAnswerEndpoint'] as String? ?? '',
      tapToRecordLabel: actions['tapToRecord'] as String? ?? 'Tap to record',
      hearQuestionAgainLabel:
          actions['hearQuestionAgain'] as String? ?? 'Hear question again',
      cues: tips.whereType<Map>().toList().asMap().entries.map((entry) {
        final tip = Map<String, dynamic>.from(entry.value);
        return PracticePillarCueModel(
          title: tip['title'] as String? ?? '',
          question: tip['description'] as String? ?? '',
          iconKey: _iconForTip(tip['title'] as String?, entry.key, cueIcons),
        );
      }).toList(),
    );
  }

  factory PracticeQuestionModel.initial() {
    return PracticeQuestionModel(
      stepTag: 'PRACTICE · QUESTION 1 OF 3',
      questionIndex: 1,
      totalQuestions: 3,
      chips: const ['Job Interview', 'Warm HR Partner', 'Challenge Mode'],
      headline: "Good. Now let's make it real.",
      coachContext:
          'You mentioned leading a project team. Bring that into the room with you.',
      countsTag: 'This one counts.',
      speakerRole: 'Warm HR Partner Ask:',
      videoDuration: '0:14',
      questionText: 'Tell me about a time you made a difficult decision.',
      supportTip:
          'A little support, if you want it. Open a guide and come straight back to this question.',
      yourMove:
          'Bring the people affected by your decision into the answer. Help everyone listening understand why it mattered.',
      cues: PracticeCuesGuidanceModel.initial().cues,
    );
  }

  static String _iconForTip(String? title, int index, List<String> icons) {
    final key = (title ?? '').toLowerCase();
    if (key.contains('focused')) return 'target';
    if (key.contains('power') || key.contains('speech')) return 'sound';
    if (key.contains('quick')) return 'clock';
    if (key.contains('impression')) return 'chat';
    if (key.contains('energy') || key.contains('warmth')) return 'heart';
    if (key.contains('semitone')) return 'sound';
    if (key.contains('shackleton')) return 'target';
    if (key.contains('ikebana')) return 'target';
    if (key.contains('private')) return 'chat';
    return icons[index % icons.length];
  }
}
