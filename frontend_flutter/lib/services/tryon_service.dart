// ============================================================
// tryon_service.dart — Try‑On API Service
// ============================================================

import 'dart:io';
import 'package:virtual_tryon_ai/services/api_service.dart';
import 'package:virtual_tryon_ai/services/api_constants.dart';

class TryOnService {
  final ApiService _api = ApiService();

  /// Starts a try‑on session by uploading the user photo and the selected product ID.
  /// Returns a session ID that can be polled for the AI result.
  Future<String> startSession({required File userPhoto, required String productId, void Function(int, int)? onProgress}) async {
    try {
      return await _api.startTryOnSession(
        userPhoto: userPhoto,
        productId: productId,
        onProgress: onProgress,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Polls the backend for the try‑on result using the provided [sessionId].
  /// Calls [onProgress] with a double between 0 and 1 indicating polling progress.
  /// Returns the URL of the generated try‑on image when processing is complete.
  Future<String> pollResult({required String sessionId, void Function(double)? onProgress}) async {
    try {
      return await _api.pollTryOnResult(sessionId: sessionId, onProgress: onProgress);
    } catch (e) {
      rethrow;
    }
  }
}
