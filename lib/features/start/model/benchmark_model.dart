class BenchmarkQuestionModel {
  final String id;
  final String title;
  int? selectedIndex; // 0: Rarely, 1: Sometimes, 2: Often, 3: Usually, 4: Always

  BenchmarkQuestionModel({
    required this.id,
    required this.title,
    this.selectedIndex,
  });

  factory BenchmarkQuestionModel.fromJson(Map<String, dynamic> json) {
    return BenchmarkQuestionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      selectedIndex: json['selected_index'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'selected_index': selectedIndex,
    };
  }
}

/// Request body for POST /api/v1/assessment/self-assessment
class SelfAssessmentRequest {
  final String confidence;
  final String authority;
  final String communication;

  const SelfAssessmentRequest({
    required this.confidence,
    required this.authority,
    required this.communication,
  });

  Map<String, dynamic> toJson() {
    return {
      'confidence': confidence,
      'authority': authority,
      'communication': communication,
    };
  }

  factory SelfAssessmentRequest.fromJson(Map<String, dynamic> json) {
    return SelfAssessmentRequest(
      confidence: json['confidence'] as String? ?? '',
      authority: json['authority'] as String? ?? '',
      communication: json['communication'] as String? ?? '',
    );
  }
}

/// Inner data payload of self-assessment response
class SelfAssessmentData {
  final String assessmentId;
  final String status;
  final String confidence;
  final String authority;
  final String communication;

  const SelfAssessmentData({
    required this.assessmentId,
    required this.status,
    required this.confidence,
    required this.authority,
    required this.communication,
  });

  factory SelfAssessmentData.fromJson(Map<String, dynamic> json) {
    return SelfAssessmentData(
      assessmentId: json['assessment_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      confidence: json['confidence'] as String? ?? '',
      authority: json['authority'] as String? ?? '',
      communication: json['communication'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assessment_id': assessmentId,
      'status': status,
      'confidence': confidence,
      'authority': authority,
      'communication': communication,
    };
  }
}

/// Top-level response for POST /api/v1/assessment/self-assessment
class SelfAssessmentResponse {
  final bool success;
  final SelfAssessmentData? data;
  final String? message;

  const SelfAssessmentResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SelfAssessmentResponse.fromJson(Map<String, dynamic> json) {
    return SelfAssessmentResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? SelfAssessmentData.fromJson(json['data'] as Map<String, dynamic>)
          : (json['data'] != null && json['data'] is Map
              ? SelfAssessmentData.fromJson(
                  Map<String, dynamic>.from(json['data'] as Map),
                )
              : null),
      message: json['message'] as String?,
    );
  }
}
