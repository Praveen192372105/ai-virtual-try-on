// ============================================================
// upload_photo_screen.dart — User Photo Capture Screen
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Screen where users capture or select a photo of themselves.
//   Supports camera capture, gallery selection, interactive previewing
//   across Web/Mobile platforms, and displays processing instructions.
// ============================================================

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../providers/tryon_provider.dart';

class UploadPhotoScreen extends StatefulWidget {
  static const routeName = '/upload-photo';
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isPicking = false;

  // ── Image Source Selector ──────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    if (_isPicking) return;
    setState(() => _isPicking = true);

    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (picked != null) {
        setState(() {
          _imageFile = picked;
        });
      }
    } catch (e) {
      _showError('Failed to capture image: $e');
    } finally {
      setState(() => _isPicking = false);
    }
  }

  void _clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

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

  // ── Proceed to Processing ──────────────────────────────────
  void _onContinue() {
    if (_imageFile == null) return;

    // Convert XFile to File (if not web) and set it in TryOnProvider
    if (!kIsWeb) {
      context.read<TryOnProvider>().setUserPhoto(File(_imageFile!.path));
    }
    
    // Go to next step / processing screen
    Navigator.pop(context, _imageFile!.path);
  }

  // ── Build ─────────────────────────────────────────────────
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
        title: const Text(
          'Capture User Photo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Gradient Circles
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryPurple.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentCyan.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Layouts ───────────────────────────────────────────────
  Widget _buildPortraitLayout() {
    return Column(
      children: [
        // 1. User Photo Preview Area
        Expanded(
          flex: 5,
          child: _buildPreviewArea(),
        ),
        const SizedBox(height: 20),

        // 2. Instructions Card
        _buildInstructionsCard(),
        const SizedBox(height: 20),

        // 3. Actions Button Container
        _buildActionButtons(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Preview Area Left
        Expanded(
          flex: 1,
          child: _buildPreviewArea(),
        ),
        const SizedBox(width: 20),

        // 2. Info + Buttons Right
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInstructionsCard(),
                const SizedBox(height: 20),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Sub-Widgets ───────────────────────────────────────────
  Widget _buildPreviewArea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: _imageFile != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  kIsWeb
                      ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                      : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                  // Darken overlay at bottom for controls contrast
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                      ),
                      child: const Icon(
                        Icons.add_a_photo_outlined,
                        color: AppTheme.primaryPurple,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Photo Selected',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Take a photo or pick from gallery to begin',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: AppTheme.accentCyan, size: 20),
              SizedBox(width: 8),
              Text(
                'AI Capture Instructions',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _instructionRow(Icons.accessibility_new_rounded, 'Stand straight with arms relaxed'),
          const SizedBox(height: 8),
          _instructionRow(Icons.wb_sunny_outlined, 'Ensure good, even studio lighting'),
          const SizedBox(height: 8),
          _instructionRow(Icons.crop_original_rounded, 'Make sure your entire body is visible'),
        ],
      ),
    );
  }

  Widget _instructionRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_imageFile != null) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearImage,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.errorColor),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Retake',
                style: TextStyle(color: AppTheme.errorColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
            label: const Text('Gallery', style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            label: const Text('Camera', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
