// ============================================================
// ai_processing_screen.dart — AI Processing Screen (real backend integration)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/app_theme.dart';
import '../providers/tryon_provider.dart';
import '../screens/tryon_result_screen.dart';

class AIProcessingScreen extends StatelessWidget {
  static const routeName = '/ai-processing';

  const AIProcessingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Processing', style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: Consumer<TryOnProvider>(
        builder: (context, provider, child) {
          // Show different UI based on provider status
          if (provider.status == TryOnStatus.error) {
            return _buildError(context, provider.errorMessage ?? 'Unknown error');
          }
          if (provider.status == TryOnStatus.done && provider.resultImageUrl != null) {
            // Navigate to result screen after a short delay
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(
                TryOnResultScreen.routeName,
                arguments: {
                  'originalImage': provider.userPhoto?.path ?? '',
                  'resultImage': provider.resultImageUrl!,
                  'product': provider.selectedProduct,
                },
              );
            });
            return const Center(child: CircularProgressIndicator(color: AppTheme.accentCyan));
          }
          // Idle, uploading, or processing states show progress UI
          return _buildProgress(context, provider);
        },
      ),
    );
  }

  Widget _buildProgress(BuildContext context, TryOnProvider provider) {
    final stage = provider.status == TryOnStatus.uploading ? 'Uploading image...' : 'Processing try‑on...';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular progress reflecting overall progress (0‑1)
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: provider.progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  color: AppTheme.accentCyan,
                ),
                Text(
                  '\${(provider.progress * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(stage, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          Text(message, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _stages[index],
                    style: TextStyle(
                      color: isCompleted || isCurrent ? Colors.white : Colors.white38,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
