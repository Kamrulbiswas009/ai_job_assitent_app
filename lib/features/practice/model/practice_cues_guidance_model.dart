class PracticePillarCueModel {
  final String title;
  final String question;
  final String iconKey;

  const PracticePillarCueModel({
    required this.title,
    required this.question,
    required this.iconKey,
  });

  factory PracticePillarCueModel.fromJson(Map<String, dynamic> json) {
    return PracticePillarCueModel(
      title: json['title'] as String? ?? '',
      question: json['question'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? 'target',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'question': question,
        'iconKey': iconKey,
      };
}

class PracticeCuesGuidanceModel {
  final String stepTag;
  final List<String> chips;
  final List<PracticePillarCueModel> cues;

  const PracticeCuesGuidanceModel({
    required this.stepTag,
    required this.chips,
    required this.cues,
  });

  factory PracticeCuesGuidanceModel.initial() {
    return const PracticeCuesGuidanceModel(
      stepTag: 'PRACTICE · QUESTION 1 OF 3',
      chips: ['Job Interview', 'Warm HR Partner', 'Challenge Mode'],
      cues: [
        PracticePillarCueModel(
          title: 'Focused Entry',
          question: 'How do I feed the whole room?',
          iconKey: 'target',
        ),
        PracticePillarCueModel(
          title: 'Power Through Speech',
          question: 'What is this pillar teaching me?',
          iconKey: 'sound',
        ),
        PracticePillarCueModel(
          title: 'Quick Quick Slow',
          question: 'How do I make my strongest words land?',
          iconKey: 'clock',
        ),
        PracticePillarCueModel(
          title: 'First Impression',
          question: 'How do I begin with warmth and purpose?',
          iconKey: 'chat',
        ),
        PracticePillarCueModel(
          title: 'Energy & Warmth',
          question: 'What should I bring into the room?',
          iconKey: 'heart',
        ),
      ],
    );
  }

  factory PracticeCuesGuidanceModel.fromJson(Map<String, dynamic> json) {
    return PracticeCuesGuidanceModel(
      stepTag: json['stepTag'] as String? ?? 'PRACTICE · QUESTION 1 OF 3',
      chips: (json['chips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Job Interview', 'Warm HR Partner', 'Challenge Mode'],
      cues: (json['cues'] as List<dynamic>?)
              ?.map((e) =>
                  PracticePillarCueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'stepTag': stepTag,
        'chips': chips,
        'cues': cues.map((e) => e.toJson()).toList(),
      };
}
