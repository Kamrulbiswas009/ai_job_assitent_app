class TrainingPathInfo {
  final String pillar;
  final String focus1;
  final String focus2;

  const TrainingPathInfo({
    required this.pillar,
    required this.focus1,
    required this.focus2,
  });

  factory TrainingPathInfo.fromJson(Map<String, dynamic> json) {
    return TrainingPathInfo(
      pillar: json['pillar'] as String? ?? '',
      focus1: json['focus1'] as String? ?? '',
      focus2: json['focus2'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pillar': pillar,
      'focus1': focus1,
      'focus2': focus2,
    };
  }
}

class InfluenceScoreModel {
  final int startingScore;
  final int targetScore;
  final String baselineSummary;
  final List<TrainingPathInfo> trainingPath;

  const InfluenceScoreModel({
    required this.startingScore,
    required this.targetScore,
    required this.baselineSummary,
    required this.trainingPath,
  });

  factory InfluenceScoreModel.fromJson(Map<String, dynamic> json) {
    return InfluenceScoreModel(
      startingScore: json['starting_score'] as int? ?? 59,
      targetScore: json['target_score'] as int? ?? 85,
      baselineSummary: json['baseline_summary'] as String? ?? '',
      trainingPath: (json['training_path'] as List<dynamic>?)
              ?.map((e) => TrainingPathInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starting_score': startingScore,
      'target_score': targetScore,
      'baseline_summary': baselineSummary,
      'training_path': trainingPath.map((e) => e.toJson()).toList(),
    };
  }
}
