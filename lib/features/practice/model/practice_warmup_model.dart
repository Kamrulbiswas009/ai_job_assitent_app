class PracticeWarmupModel {
  final String badge;
  final String title;
  final String subtitle;
  final String alertTitle;
  final String alertDescription;
  final String promptCategory;
  final String promptQuestion;
  final int targetDurationSeconds;

  const PracticeWarmupModel({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.alertTitle,
    required this.alertDescription,
    required this.promptCategory,
    required this.promptQuestion,
    this.targetDurationSeconds = 60,
  });

  factory PracticeWarmupModel.initial() {
    return const PracticeWarmupModel(
      badge: 'WARM - UP',
      title: 'Get your voice moving before the interview begins.',
      subtitle:
          'Choose who SpeechPro will roleplay and how challenging you want this first session to be.',
      alertTitle: "THIS DOESN'T COUNT TOWARD YOUR SCORE",
      alertDescription:
          'This is a warm-up, not an interview question. Speak naturally. You can record it again if you want to.',
      promptCategory: 'PRACTICE CUES',
      promptQuestion: 'Tell me one thing you are proud of professionally.',
      targetDurationSeconds: 60,
    );
  }

  factory PracticeWarmupModel.fromJson(Map<String, dynamic> json) {
    return PracticeWarmupModel(
      badge: json['badge'] as String? ?? 'WARM - UP',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      alertTitle: json['alertTitle'] as String? ?? '',
      alertDescription: json['alertDescription'] as String? ?? '',
      promptCategory: json['promptCategory'] as String? ?? 'PRACTICE CUES',
      promptQuestion: json['promptQuestion'] as String? ?? '',
      targetDurationSeconds: json['targetDurationSeconds'] as int? ?? 60,
    );
  }

  Map<String, dynamic> toJson() => {
        'badge': badge,
        'title': title,
        'subtitle': subtitle,
        'alertTitle': alertTitle,
        'alertDescription': alertDescription,
        'promptCategory': promptCategory,
        'promptQuestion': promptQuestion,
        'targetDurationSeconds': targetDurationSeconds,
      };
}
