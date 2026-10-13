class PracticeQuestionModel {
  final String stepTag;
  final List<String> chips;
  final String headline;
  final String coachContext;
  final String countsTag;
  final String speakerRole;
  final String videoDuration;
  final String questionText;
  final String supportTip;
  final String yourMove;

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
  });

  factory PracticeQuestionModel.initial() {
    return const PracticeQuestionModel(
      stepTag: 'PRACTICE · QUESTION 1 OF 3',
      chips: ['Job Interview', 'Warm HR Partner', 'Challenge Mode'],
      headline: "Good. Now let's make it real.",
      coachContext:
          'You mentioned leading a project team. Bring that into the room with you.',
      countsTag: 'This one counts.',
      speakerRole: 'WARM HR PARTNER ASK:',
      videoDuration: '0:14',
      questionText: 'Tell me about a time you made a difficult decision.',
      supportTip:
          'A little support, if you want it: Open a guide and come straight back to this question.',
      yourMove:
          'Bring the people affected by your decision into the answer; help everyone listening understand why it mattered.',
    );
  }

  factory PracticeQuestionModel.fromJson(Map<String, dynamic> json) {
    return PracticeQuestionModel(
      stepTag: json['stepTag'] as String? ?? 'PRACTICE · QUESTION 1 OF 3',
      chips: (json['chips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Job Interview', 'Warm HR Partner', 'Challenge Mode'],
      headline: json['headline'] as String? ?? "Good. Now let's make it real.",
      coachContext: json['coachContext'] as String? ?? '',
      countsTag: json['countsTag'] as String? ?? 'This one counts.',
      speakerRole: json['speakerRole'] as String? ?? 'WARM HR PARTNER ASK:',
      videoDuration: json['videoDuration'] as String? ?? '0:14',
      questionText: json['questionText'] as String? ?? '',
      supportTip: json['supportTip'] as String? ?? '',
      yourMove: json['yourMove'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'stepTag': stepTag,
        'chips': chips,
        'headline': headline,
        'coachContext': coachContext,
        'countsTag': countsTag,
        'speakerRole': speakerRole,
        'videoDuration': videoDuration,
        'questionText': questionText,
        'supportTip': supportTip,
        'yourMove': yourMove,
      };
}
