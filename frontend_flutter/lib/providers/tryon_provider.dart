// ============================================================
// tryon_provider.dart — Virtual Try-On Session State
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Manages the entire try-on pipeline state: user photo capture,
//   product selection, AI processing request, and result display.
// ============================================================

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';

enum TryOnStatus { idle, uploading, processing, done, error }

class TryOnProvider with ChangeNotifier {
  final ApiService _api;

  // ── State ─────────────────────────────────────────────────
  File?          _userPhoto;        // Photo taken by user camera
  ProductModel?  _selectedProduct;  // Product chosen for try-on
  String?        _resultImageUrl;   // URL of AI-generated try-on result
  TryOnStatus    _status = TryOnStatus.idle;
  String?        _errorMessage;
  double         _progress = 0.0;   // Upload/processing progress (0.0–1.0)

  // ── Getters ───────────────────────────────────────────────
  File?          get userPhoto       => _userPhoto;
  ProductModel?  get selectedProduct => _selectedProduct;
  String?        get resultImageUrl  => _resultImageUrl;
  TryOnStatus    get status          => _status;
  String?        get errorMessage    => _errorMessage;
  double         get progress        => _progress;
  bool           get isProcessing    =>
      _status == TryOnStatus.uploading || _status == TryOnStatus.processing;
  bool           get hasResult       => _status == TryOnStatus.done && _resultImageUrl != null;

  TryOnProvider(this._api);

  // ── Set User Photo (from camera or gallery) ───────────────
  void setUserPhoto(File photo) {
    _userPhoto = photo;
    _resultImageUrl = null; // Clear previous result
    _status = TryOnStatus.idle;
    notifyListeners();
  }

  // ── Select Product for Try-On ─────────────────────────────
  void selectProduct(ProductModel product) {
    _selectedProduct = product;
    notifyListeners();
  }

  // ── Start AI Try-On Pipeline ──────────────────────────────
  Future<void> startTryOn({String? token}) async {
    if (_userPhoto == null || _selectedProduct == null) {
      _errorMessage = 'Please select both a photo and a product.';
      notifyListeners();
      return;
    }

    _status = TryOnStatus.uploading;
    _progress = 0.0;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Upload user photo and product ID to backend
      final sessionId = await _api.startTryOnSession(
        userPhoto: _userPhoto!,
        productId: _selectedProduct!.id,
        token: token,
      );

      _status = TryOnStatus.processing;
      _progress = 0.5;
      notifyListeners();

      // Step 2: Poll for AI result until done
      _resultImageUrl = await _api.pollTryOnResult(
        sessionId: sessionId,
        token: token,
        onProgress: (p) {
          _progress = 0.5 + (p * 0.5); // Last 50% = AI processing
          notifyListeners();
        },
      );

      _status = TryOnStatus.done;
      _progress = 1.0;
      notifyListeners();

    } catch (e) {
      _status = TryOnStatus.error;
      _errorMessage = 'Try-on failed: ${e.toString()}';
      notifyListeners();
    }
  }

  // ── Reset Session ─────────────────────────────────────────
  void reset() {
    _userPhoto       = null;
    _selectedProduct = null;
    _resultImageUrl  = null;
    _status          = TryOnStatus.idle;
    _errorMessage    = null;
    _progress        = 0.0;
    notifyListeners();
  }
}
