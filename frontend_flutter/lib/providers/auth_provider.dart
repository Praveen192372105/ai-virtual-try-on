// ============================================================
// auth_provider.dart — Authentication State Management
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Manages login, registration, logout, and JWT token storage.
//   Exposes authenticated user state to all widgets via Provider.
// ============================================================

import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService      _api;
  final StorageService  _storage;

  // ── State ─────────────────────────────────────────────────
  UserModel? _user;
  String?    _token;
  String?    _errorMessage;
  bool       _isLoading = false;

  // ── Getters ───────────────────────────────────────────────
  UserModel? get user         => _user;
  String?    get token        => _token;
  String?    get errorMessage => _errorMessage;
  bool       get isLoading    => _isLoading;
  bool       get isLoggedIn   => _token != null && _user != null;

  AuthProvider(this._api, this._storage) {
    _restoreSession(); // Auto-login if token exists
  }

  // ── Restore Session from Storage ──────────────────────────
  Future<void> _restoreSession() async {
    _token = await _storage.getToken();
    if (_token != null) {
      try {
        final cachedUserJson = _storage.getUser();
        if (cachedUserJson != null) {
          _user = UserModel.fromJson(jsonDecode(cachedUserJson) as Map<String, dynamic>);
        } else {
          final userData = await _api.getProfile(_token!);
          _user = UserModel.fromJson(userData);
          await _storage.saveUser(jsonEncode(_user!.toJson()));
        }
      } catch (_) {
        // Token expired or invalid — clear it
        await _storage.clearToken();
        await _storage.clearUser();
        _token = null;
        _user = null;
      }
    }
    notifyListeners();
  }

  // ── Login ─────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _api.login(email: email, password: password);
      _token = response['token'] as String;
      _user  = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      await _storage.saveToken(_token!);
      await _storage.saveUser(jsonEncode(_user!.toJson()));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Register ──────────────────────────────────────────────
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _api.register(name: name, email: email, password: password);
      _token = response['token'] as String;
      _user  = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      await _storage.saveToken(_token!);
      await _storage.saveUser(jsonEncode(_user!.toJson()));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ── Logout ────────────────────────────────────────────────
  Future<void> logout() async {
    _user  = null;
    _token = null;
    await _storage.clearToken();
    await _storage.clearUser();
    notifyListeners();
  }

  // ── Helper ────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
