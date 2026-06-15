// ============================================================
// storage_service.dart — Local Persistent Storage
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Wraps shared_preferences to persist JWT token and user prefs
//   across app sessions (survives app restarts).
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _themeKey = 'dark_mode';

  late SharedPreferences _prefs;

  // ── Must call before use ──────────────────────────────────
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Token Management ──────────────────────────────────────
  Future<void> saveToken(String token) async => _prefs.setString(_tokenKey, token);
  String?      getToken()               => _prefs.getString(_tokenKey);
  Future<void> clearToken()             async => _prefs.remove(_tokenKey);

  // ── User Management ───────────────────────────────────────
  Future<void> saveUser(String userJson) async => _prefs.setString('auth_user', userJson);
  String?      getUser()                 => _prefs.getString('auth_user');
  Future<void> clearUser()               async => _prefs.remove('auth_user');

  // ── App Preferences ───────────────────────────────────────
  bool         isDarkMode()                => _prefs.getBool(_themeKey) ?? true;
  Future<void> setDarkMode(bool value)     async => _prefs.setBool(_themeKey, value);
}
