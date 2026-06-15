// ============================================================
// camera_screen.dart — Live Camera Capture Screen
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Provides a full‑screen live camera view with permission handling,
//   capture button, front/back switch, flash toggle, retake preview and
//   continue flow. Implements a modern dark glass‑morphic UI using
//   Material Design 3 and adapts to portrait/landscape sizes.
// ============================================================

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../providers/tryon_provider.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera';
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isRearCamera = true;
  FlashMode _flashMode = FlashMode.off;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Camera setup ────────────────────────────────────────
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw CameraException('NoCamera', 'No cameras found on device');
      }
      final camera = _cameras.firstWhere(
        (c) => _isRearCamera ? c.lensDirection == CameraLensDirection.back : c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();
      await _controller!.setFlashMode(_flashMode);
      setState(() => _isCameraInitialized = true);
    } on CameraException catch (e) {
      _showError('Camera error: ${e.description ?? e.code}');
    } catch (e) {
      _showError('Unexpected error: $e');
    }
  }

  // ── UI Helpers ────────────────────────────────────────
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Capture flow ───────────────────────────────────────
  Future<void> _capturePhoto() async {
    if (!_isCameraInitialized || _controller == null) return;
    try {
      final file = await _controller!.takePicture();
      setState(() => _capturedImage = file);
    } on CameraException catch (e) {
      _showError('Capture failed: ${e.description ?? e.code}');
    }
  }

  void _switchCamera() async {
    if (_cameras.length < 2) return; // nothing to switch
    setState(() {
      _isRearCamera = !_isRearCamera;
      _isCameraInitialized = false;
      _controller?.dispose();
    });
    await _initializeCamera();
  }

  void _toggleFlash() async {
    if (_controller == null) return;
    final newMode = _flashMode == FlashMode.off ? FlashMode.auto : FlashMode.off;
    try {
      await _controller!.setFlashMode(newMode);
      setState(() => _flashMode = newMode);
    } on CameraException catch (e) {
      _showError('Flash toggle failed: ${e.description ?? e.code}');
    }
  }

  // ── Continue flow ───────────────────────────────────────
  void _continue() {
    if (_capturedImage == null) return;
    // Store image in TryOnProvider (or any other central storage) and pop back.
    if (!kIsWeb) {
      context.read<TryOnProvider>().setUserPhoto(File(_capturedImage!.path));
    }
    Navigator.pop(context, _capturedImage!.path);
  }

  // ── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Capture Photo', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // Ambient glow background (optional aesthetic)
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryPurple.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentCyan.withValues(alpha: 0.09),
              ),
            ),
          ),

          // Main content – either live preview or captured image preview
          SafeArea(
            child: Center(
              child: _capturedImage == null
                  ? _buildLiveCamera(context)
                  : _buildCapturedPreview(context),
            ),
          ),
        ],
      ),
    );
  }

  // ── Live camera view with controls ───────────────────────
  Widget _buildLiveCamera(BuildContext context) {
    return _isCameraInitialized && _controller != null
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Camera preview fills the space
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
              // Controls overlay
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Switch camera
                    IconButton(
                      icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 28),
                      onPressed: _switchCamera,
                    ),
                    // Capture button (larger)
                    GestureDetector(
                      onTap: _capturePhoto,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white70, width: 4),
                          color: AppTheme.primaryPurple.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    // Flash toggle
                    IconButton(
                      icon: Icon(
                        _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _toggleFlash,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(color: AppTheme.primaryPurple),
                SizedBox(height: 16),
                Text('Initializing camera...', style: TextStyle(color: Colors.white70)),
              ],
            ),
          );
  }

  // ── Captured image preview with retake / continue actions ─────
  Widget _buildCapturedPreview(BuildContext context) {
    final imageWidget = kIsWeb
        ? Image.network(_capturedImage!.path, fit: BoxFit.contain)
        : Image.file(File(_capturedImage!.path), fit: BoxFit.contain);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Center(child: imageWidget)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Retake button
            OutlinedButton.icon(
              onPressed: () => setState(() => _capturedImage = null),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Retake', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white38),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            // Continue button
            ElevatedButton.icon(
              onPressed: _continue,
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              label: const Text('Continue', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
