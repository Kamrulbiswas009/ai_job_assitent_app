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
