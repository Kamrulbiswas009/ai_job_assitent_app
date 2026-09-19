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
      focus1: json['focus1'] as String? ?? json['focus_1'] as String? ?? '',
      focus2: json['focus2'] as String? ?? json['focus_2'] as String? ?? '',
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

/// 6 Dimension Scores from Step 5 API
class DimensionScores {
  final int confidence;
  final int presence;
  final int authority;
  final int leadership;
  final int persuasion;
  final int communication;

  const DimensionScores({
    this.confidence = 52,
    this.presence = 61,
    this.authority = 48,
    this.leadership = 55,
    this.persuasion = 59,
    this.communication = 63,
  });

  factory DimensionScores.fromJson(Map<String, dynamic> json) {
    return DimensionScores(
      confidence: json['confidence'] as int? ?? 52,
      presence: json['presence'] as int? ?? 61,
      authority: json['authority'] as int? ?? 48,
      leadership: json['leadership'] as int? ?? 55,
      persuasion: json['persuasion'] as int? ?? 59,
      communication: json['communication'] as int? ?? 63,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confidence': confidence,
      'presence': presence,
      'authority': authority,
      'leadership': leadership,
      'persuasion': persuasion,
      'communication': communication,
    };
  }
}

/// Interpretation from Step 5 API
class AssessmentInterpretation {
  final String range;
  final String title;
  final String description;

  const AssessmentInterpretation({
    this.range = '50-69',
    this.title = 'Developing',
    this.description =
        'There is real instinct here.\n\nBut instinct is not yet technique. You can feel what you want to say, but under pressure it is not landing with enough structure, authority or control. That gap is exactly what this system is built to close.\n\nSpeechPro turns raw communication instinct into repeatable command.\n\nYour first session starts now',
  });

  factory AssessmentInterpretation.fromJson(Map<String, dynamic> json) {
    return AssessmentInterpretation(
      range: json['range'] as String? ?? '50-69',
      title: json['title'] as String? ?? 'Developing',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'range': range,
      'title': title,
      'description': description,
    };
  }
}

/// Training Path from Step 5 API
class TrainingPath {
  final String pillar;
  final String focus1;
  final String focus2;

  const TrainingPath({
    this.pillar = 'Power Through Speech',
    this.focus1 = 'The Voice of Authority.',
    this.focus2 = 'Yi — The Power of Intent',
  });

  factory TrainingPath.fromJson(Map<String, dynamic> json) {
    return TrainingPath(
      pillar: json['pillar'] as String? ?? 'Power Through Speech',
      focus1: json['focus_1'] as String? ?? json['focus1'] as String? ?? 'The Voice of Authority.',
      focus2: json['focus_2'] as String? ?? json['focus2'] as String? ?? 'Yi — The Power of Intent',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pillar': pillar,
      'focus_1': focus1,
      'focus_2': focus2,
    };
  }
}

/// Full Result Response for GET /api/v1/assessment/{assessment_id}/result
class AssessmentResultResponse {
  final String assessmentId;
  final int influenceScore;
  final DimensionScores dimensions;
  final AssessmentInterpretation interpretation;
  final TrainingPath trainingPath;

  const AssessmentResultResponse({
    required this.assessmentId,
    required this.influenceScore,
    required this.dimensions,
    required this.interpretation,
    required this.trainingPath,
  });

  factory AssessmentResultResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentResultResponse(
      assessmentId: json['assessment_id'] as String? ?? '',
      influenceScore: json['influence_score'] as int? ?? 59,
      dimensions: json['dimensions'] != null && json['dimensions'] is Map
          ? DimensionScores.fromJson(Map<String, dynamic>.from(json['dimensions'] as Map))
          : const DimensionScores(),
      interpretation: json['interpretation'] != null && json['interpretation'] is Map
          ? AssessmentInterpretation.fromJson(
              Map<String, dynamic>.from(json['interpretation'] as Map),
            )
          : const AssessmentInterpretation(),
      trainingPath: json['training_path'] != null && json['training_path'] is Map
          ? TrainingPath.fromJson(Map<String, dynamic>.from(json['training_path'] as Map))
          : const TrainingPath(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessment_id': assessmentId,
      'influence_score': influenceScore,
      'dimensions': dimensions.toJson(),
      'interpretation': interpretation.toJson(),
      'training_path': trainingPath.toJson(),
    };
  }

  static const fallback = AssessmentResultResponse(
    assessmentId: '',
    influenceScore: 59,
    dimensions: DimensionScores(
      confidence: 52,
      presence: 61,
      authority: 48,
      leadership: 55,
      persuasion: 59,
      communication: 63,
    ),
    interpretation: AssessmentInterpretation(
      range: '50-69',
      title: 'Developing',
      description:
          'There is real instinct here.\n\nBut instinct is not yet technique. You can feel what you want to say, but under pressure it is not landing with enough structure, authority or control. That gap is exactly what this system is built to close.\n\nSpeechPro turns raw communication instinct into repeatable command.\n\nYour first session starts now',
    ),
    trainingPath: TrainingPath(
      pillar: 'Power Through Speech',
      focus1: 'The Voice of Authority.',
      focus2: 'Yi — The Power of Intent',
    ),
  );
}
