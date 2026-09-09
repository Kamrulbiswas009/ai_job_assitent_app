class GoalDetailsModel {
  final String goalId;
  final String keywords;
  final String roleApplying;
  final String? voiceAnswerPath;
  final String additionalNotes;

  const GoalDetailsModel({
    required this.goalId,
    required this.keywords,
    required this.roleApplying,
    this.voiceAnswerPath,
    required this.additionalNotes,
  });

  factory GoalDetailsModel.fromJson(Map<String, dynamic> json) {
    return GoalDetailsModel(
      goalId: json['goal_id'] as String? ?? '',
      keywords: json['keywords'] as String? ?? '',
      roleApplying: json['role_applying'] as String? ?? '',
      voiceAnswerPath: json['voice_answer_path'] as String?,
      additionalNotes: json['additional_notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'keywords': keywords,
      'role_applying': roleApplying,
      'voice_answer_path': voiceAnswerPath,
      'additional_notes': additionalNotes,
    };
  }
}
