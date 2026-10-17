import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_session_model.dart';

class StorageService {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _idKey = 'userId';
  static const String _emailKey = 'userEmail';
  static const String _fullNameKey = 'userName';
  static const String _assessmentIdKey = 'assessmentId';
  static const String _voiceSkippedKey = 'voiceCalibrationSkipped';
  static const String _isSubscribedKey = 'isSubscribed';
  static const String _savedSessionKey = 'savedLastSession';

  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Check if token exists
  static bool hasToken() {
    final token = _preferences?.getString(_accessTokenKey);
    return token != null && token.isNotEmpty;
  }

  // Save auth data
  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    String? userId,
    String? email,
    String? fullName,
    bool? isSubscribed,
  }) async {
    await _preferences?.setString(_accessTokenKey, accessToken);
    await _preferences?.setString(_refreshTokenKey, refreshToken);
    if (userId != null) await _preferences?.setString(_idKey, userId);
    if (email != null) await _preferences?.setString(_emailKey, email);
    if (fullName != null) await _preferences?.setString(_fullNameKey, fullName);
    if (isSubscribed != null) {
      await _preferences?.setBool(_isSubscribedKey, isSubscribed);
    }
  }

  // Save tokens only
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _preferences?.setString(_accessTokenKey, accessToken);
    await _preferences?.setString(_refreshTokenKey, refreshToken);
  }

  // Save pending verification email
  static Future<void> saveEmail(String email) async {
    await _preferences?.setString(_emailKey, email);
  }

  // Save assessment ID (Step 3 -> 4, 5)
  static Future<void> saveAssessmentId(String assessmentId) async {
    await _preferences?.setString(_assessmentIdKey, assessmentId);
  }

  // Save voice calibration skipped status
  static Future<void> saveVoiceSkipped(bool skipped) async {
    await _preferences?.setBool(_voiceSkippedKey, skipped);
  }

  // Save subscription status
  static Future<void> saveIsSubscribed(bool isSubscribed) async {
    await _preferences?.setBool(_isSubscribedKey, isSubscribed);
  }

  // Save active session snapshot for seamless resumption after logout
  static Future<void> saveCurrentSession({
    required String route,
    String? title,
    String? scenarioSlug,
    String? assessmentId,
    Map<String, dynamic>? arguments,
  }) async {
    try {
      if (!SavedSessionModel.isResumableRoute(route)) return;
      final session = SavedSessionModel(
        route: route,
        title: title ?? SavedSessionModel.resolveRouteTitle(route),
        scenarioSlug: scenarioSlug,
        assessmentId: assessmentId ?? StorageService.assessmentId,
        arguments: arguments,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      await _preferences?.setString(_savedSessionKey, session.encode());
    } catch (_) {}
  }

  // Retrieve saved session
  static SavedSessionModel? getLastSession() {
    try {
      final raw = _preferences?.getString(_savedSessionKey);
      return SavedSessionModel.decode(raw);
    } catch (_) {
      return null;
    }
  }

  // Check if a valid saved session exists
  static bool hasSavedSession() {
    final session = getLastSession();
    return session != null && SavedSessionModel.isResumableRoute(session.route);
  }

  // Clear saved session (e.g. user selected "Start Fresh")
  static Future<void> clearSavedSession() async {
    try {
      await _preferences?.remove(_savedSessionKey);
    } catch (_) {}
  }

  // Getters
  static String? get token => _preferences?.getString(_accessTokenKey);
  static String? get accessToken => _preferences?.getString(_accessTokenKey);
  static String? get refreshToken => _preferences?.getString(_refreshTokenKey);
  static String? get userId => _preferences?.getString(_idKey);
  static String? get userEmail => _preferences?.getString(_emailKey);
  static String? get fullName => _preferences?.getString(_fullNameKey);
  static String? get assessmentId => _preferences?.getString(_assessmentIdKey);
  static bool get isVoiceSkipped =>
      _preferences?.getBool(_voiceSkippedKey) ?? false;
  static bool get isSubscribed =>
      _preferences?.getBool(_isSubscribedKey) ?? false;

  // Logout / clear (preserves saved session progress by default)
  static Future<void> logoutUser({bool keepSavedSession = true}) async {
    await _preferences?.remove(_accessTokenKey);
    await _preferences?.remove(_refreshTokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_emailKey);
    await _preferences?.remove(_fullNameKey);
    await _preferences?.remove(_assessmentIdKey);
    await _preferences?.remove(_voiceSkippedKey);
    await _preferences?.remove(_isSubscribedKey);
    if (!keepSavedSession) {
      await clearSavedSession();
    }
  }
}
