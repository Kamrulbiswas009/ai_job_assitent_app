class BriefingPillarModel {
  final String title;
  final String body;

  const BriefingPillarModel({
    required this.title,
    required this.body,
  });

  factory BriefingPillarModel.fromJson(Map<String, dynamic> json) {
    return BriefingPillarModel(
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}

class PersonalBriefingModel {
  final String goalTitle;
  final String subGoal;
  final String summary;
  final List<BriefingPillarModel> pillars;
  final String coachingNote;

  const PersonalBriefingModel({
    required this.goalTitle,
    required this.subGoal,
    required this.summary,
    required this.pillars,
    required this.coachingNote,
  });

  factory PersonalBriefingModel.fromJson(Map<String, dynamic> json) {
    return PersonalBriefingModel(
      goalTitle: json['goal_title'] as String? ?? '',
      subGoal: json['sub_goal'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      pillars: (json['pillars'] as List<dynamic>?)
              ?.map((e) => BriefingPillarModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      coachingNote: json['coaching_note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_title': goalTitle,
      'sub_goal': subGoal,
      'summary': summary,
      'pillars': pillars.map((e) => e.toJson()).toList(),
      'coaching_note': coachingNote,
    };
  }
}
