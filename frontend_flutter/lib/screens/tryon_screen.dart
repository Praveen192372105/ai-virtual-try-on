// ============================================================
// tryon_screen.dart — Virtual Try-On Camera Screen
// ============================================================
import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_card.dart';
import 'package:provider/provider.dart';
import '../providers/tryon_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/ai_processing_screen.dart';

class TryOnScreen extends StatelessWidget {
  static const routeName = '/tryon';
  const TryOnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Virtual Try-On'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Camera / photo preview area
              Expanded(
                flex: 3,
                child: GlassCard(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        const Text('Take a Photo or Upload from Gallery',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54, fontSize: 16)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {}, // TODO: open camera
                          icon: const Icon(Icons.camera),
                          label: const Text('Open Camera'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Product selection row
              Expanded(
                flex: 1,
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Selected Product:', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      SizedBox(height: 8),
                      Text('No product selected — browse the catalog first',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Try-On button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryPurple, AppTheme.accentCyan]),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final tryOnProvider = context.read<TryOnProvider>();
                      final authProvider = context.read<AuthProvider>();
                      // Start the try-on pipeline
                      tryOnProvider.startTryOn(token: authProvider.token);
                      // Navigate to processing screen (no arguments needed)
                      Navigator.of(context).pushNamed(AIProcessingScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    child: const Text('✨ Start AI Try-On', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
