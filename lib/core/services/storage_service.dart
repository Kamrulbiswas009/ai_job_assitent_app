import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _idKey = 'userId';
  static const String _emailKey = 'userEmail';
  static const String _fullNameKey = 'userName';
  static const String _assessmentIdKey = 'assessmentId';

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
  }) async {
    await _preferences?.setString(_accessTokenKey, accessToken);
    await _preferences?.setString(_refreshTokenKey, refreshToken);
    if (userId != null) await _preferences?.setString(_idKey, userId);
    if (email != null) await _preferences?.setString(_emailKey, email);
    if (fullName != null) await _preferences?.setString(_fullNameKey, fullName);
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

  // Getters
  static String? get token => _preferences?.getString(_accessTokenKey);
  static String? get accessToken => _preferences?.getString(_accessTokenKey);
  static String? get refreshToken => _preferences?.getString(_refreshTokenKey);
  static String? get userId => _preferences?.getString(_idKey);
  static String? get userEmail => _preferences?.getString(_emailKey);
  static String? get fullName => _preferences?.getString(_fullNameKey);
  static String? get assessmentId => _preferences?.getString(_assessmentIdKey);

  // Logout / clear
  static Future<void> logoutUser() async {
    await _preferences?.remove(_accessTokenKey);
    await _preferences?.remove(_refreshTokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_emailKey);
    await _preferences?.remove(_fullNameKey);
    await _preferences?.remove(_assessmentIdKey);
  }
}
