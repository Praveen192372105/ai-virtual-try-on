// ============================================================
// auth_service.dart — Authentication API Service
// ============================================================

import 'package:virtual_tryon_ai/services/api_service.dart';
import 'package:virtual_tryon_ai/services/api_constants.dart';

class AuthService {
  final ApiService _api = ApiService();

  /// Login with email and password.
  /// Returns the raw response map from the backend.
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      return await _api.login(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  /// Register a new user.
  /// Returns the raw response map from the backend.
  Future<Map<String, dynamic>> signup({required String name, required String email, required String password}) async {
    try {
      return await _api.register(name: name, email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }
}
