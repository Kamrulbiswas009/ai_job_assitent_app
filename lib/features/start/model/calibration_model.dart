class VoiceCalibrationModel {
  final String? audioPath;
  final int durationSeconds;
  final bool isCompleted;

  const VoiceCalibrationModel({
    this.audioPath,
    this.durationSeconds = 0,
    this.isCompleted = false,
  });

  factory VoiceCalibrationModel.fromJson(Map<String, dynamic> json) {
    return VoiceCalibrationModel(
      audioPath: json['audio_path'] as String?,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audio_path': audioPath,
      'duration_seconds': durationSeconds,
      'is_completed': isCompleted,
    };
  }
}

/// Response payload for POST /api/v1/assessment/{assessment_id}/voice
class CalibrationVoiceResponse {
  final bool success;
  final String assessmentId;
  final String status;
  final String message;

  const CalibrationVoiceResponse({
    required this.success,
    required this.assessmentId,
    required this.status,
    required this.message,
  });

  factory CalibrationVoiceResponse.fromJson(Map<String, dynamic> json) {
    return CalibrationVoiceResponse(
      success: json['success'] as bool? ?? false,
      assessmentId: json['assessment_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'assessment_id': assessmentId,
      'status': status,
      'message': message,
    };
  }
}
