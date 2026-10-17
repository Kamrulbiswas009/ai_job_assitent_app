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

  /// Mock voice-check step before the real practice question.
  factory PracticeWarmupModel.voiceCheck({String? promptQuestion}) {
    return PracticeWarmupModel(
      badge: 'VOICE CHECK',
      title: 'Say something and hear your voice back.',
      subtitle:
          'This is a mock warm-up — check your mic and tone before Question 1. Nothing here is scored.',
      alertTitle: "THIS DOESN'T COUNT TOWARD YOUR SCORE",
      alertDescription:
          'Record a short answer, play it back, and re-record if you want. When you are happy with how you sound, continue to the roleplay question.',
      promptCategory: 'TRY SAYING',
      promptQuestion: promptQuestion?.trim().isNotEmpty == true
          ? promptQuestion!.trim()
          : 'Tell me one thing you are proud of professionally.',
      targetDurationSeconds: 60,
    );
  }

  factory PracticeWarmupModel.initial() => PracticeWarmupModel.voiceCheck();

  factory PracticeWarmupModel.fromJson(Map<String, dynamic> json) {
    return PracticeWarmupModel(
      badge: json['badge'] as String? ?? 'VOICE CHECK',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      alertTitle: json['alertTitle'] as String? ?? '',
      alertDescription: json['alertDescription'] as String? ?? '',
      promptCategory: json['promptCategory'] as String? ?? 'TRY SAYING',
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
