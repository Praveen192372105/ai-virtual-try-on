// ============================================================
// token_storage.dart — Simple JWT Token Persistence
// ============================================================
// PURPOSE:
//   Provides a lightweight wrapper around SharedPreferences for storing
//   the JWT access token returned by the FastAPI auth endpoints.
//   Separate from the richer StorageService which also handles user
//   profile caching. This file satisfies the requested token_storage
//   component without altering existing backend code.
// ============================================================

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';

  late SharedPreferences _prefs;

  // ── Must be called before any other method (e.g., in main())
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save the JWT token string
  Future<void> saveToken(String token) async => _prefs.setString(_tokenKey, token);

  // Retrieve the stored token (null if none)
  String? getToken() => _prefs.getString(_tokenKey);

  // Remove token on logout
  Future<void> clearToken() async => _prefs.remove(_tokenKey);
}
