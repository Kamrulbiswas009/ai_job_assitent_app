import 'dart:convert';

class SavedSessionModel {
  final String route;
  final String title;
  final String? scenarioSlug;
  final String? assessmentId;
  final Map<String, dynamic>? arguments;
  final int timestamp;

  const SavedSessionModel({
    required this.route,
    required this.title,
    this.scenarioSlug,
    this.assessmentId,
    this.arguments,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'route': route,
        'title': title,
        'scenarioSlug': scenarioSlug,
        'assessmentId': assessmentId,
        'arguments': arguments,
        'timestamp': timestamp,
      };

  factory SavedSessionModel.fromJson(Map<String, dynamic> json) {
    return SavedSessionModel(
      route: json['route'] as String? ?? '',
      title: json['title'] as String? ?? 'Practice Training',
      scenarioSlug: json['scenarioSlug'] as String?,
      assessmentId: json['assessmentId'] as String?,
      arguments: json['arguments'] is Map
          ? Map<String, dynamic>.from(json['arguments'] as Map)
          : null,
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }

  String encode() => jsonEncode(toJson());

  static SavedSessionModel? decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return SavedSessionModel.fromJson(decoded);
      } else if (decoded is Map) {
        return SavedSessionModel.fromJson(Map<String, dynamic>.from(decoded));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Determines if a route is an active practice/onboarding session eligible for resumption
  static bool isResumableRoute(String? route) {
    if (route == null || route.trim().isEmpty) return false;
    final r = route.trim();
    if (r == '/' ||
        r == '/splash-get-started' ||
        r == '/registration' ||
        r == '/verification' ||
        r == '/onboarding-login' ||
        r == '/forgot-password' ||
        r == '/reset-password-verification' ||
        r == '/reset-password') {
      return false;
    }
    return r.startsWith('/practice') ||
        r.startsWith('/start') ||
        r.startsWith('/about') ||
        r == '/membership' ||
        r == '/checkout' ||
        r == '/uses-of-ai';
  }

  /// Human-friendly display label for the saved session screen
  static String resolveRouteTitle(String route) {
    switch (route) {
      case '/practice-session-ready':
        return 'Practice Session Setup';
      case '/practice-coaching-brief':
        return 'Coaching Brief';
      case '/practice-warmup':
        return 'Vocal Warm-up';
      case '/practice-question':
        return 'Interactive Roleplay';
      case '/practice-cues-guidance':
        return 'Cues & Guidance';
      case '/practice-answer-record':
        return 'Record Your Answer';
      case '/practice-answer-review':
        return 'Review Your Answer';
      case '/start-step5-score':
        return 'Influence Score';
      case '/start-step4-calibration':
        return 'Voice Calibration';
      case '/start-step3-assessment':
        return 'Self-Assessment';
      case '/start-briefing':
        return 'Personal Briefing';
      case '/start-step2-details':
        return 'Session Focus';
      case '/start-step1-goals':
        return 'Scenario Goals';
      case '/start-membership-intro':
        return 'Membership Intro';
      default:
        return 'Practice Training';
    }
  }
}
