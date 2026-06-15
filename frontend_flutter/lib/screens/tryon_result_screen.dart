// ============================================================
// tryon_result_screen.dart — Try-On Result Screen
// ============================================================

import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../themes/app_theme.dart';
import '../widgets/bottom_nav_bar.dart';

class TryOnResultScreen extends StatefulWidget {
  static const routeName = '/tryon-result';
  const TryOnResultScreen({super.key});

  @override
  State<TryOnResultScreen> createState() => _TryOnResultScreenState();
}

class _TryOnResultScreenState extends State<TryOnResultScreen> {
  // The image paths are passed via arguments (original and generated).
  late final String originalImage;
  late final String resultImage;
  late final ProductModel product;

  double _sliderValue = 0.5; // start at middle

  @override
  void initState() {
    super.initState();
    // Retrieve arguments from ModalRoute
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>;
    originalImage = args['originalImage'] as String;
    resultImage = args['resultImage'] as String;
    product = args['product'] as ProductModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Try‑On Result', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Image Comparison =====
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;
                    return Stack(
                      children: [
                        // Result image (bottom layer)
                        Positioned.fill(
                          child: Image.network(
                            resultImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Original image (top layer) clipped by slider
                        Positioned.fill(
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: _sliderValue,
                              child: Image.network(
                                originalImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // Slider handle
                        Positioned(
                          left: width * _sliderValue - 12,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                _sliderValue +=
                                    details.delta.dx / width;
                                _sliderValue = _sliderValue.clamp(0.0, 1.0);
                              });
                            },
                            child: Container(
                              width: 24,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.drag_indicator,
                                  color: Colors.white70, size: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ===== Product Info Card =====
            _buildProductInfoCard(),
            const SizedBox(height: 12),
            // ===== Action Buttons =====
            _buildActionButtons(),
            const SizedBox(height: 12),
            // Bottom navigation integration
            const AppBottomNavBar(currentIndex: 2, onTap: _onNavTap),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image thumbnail
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: product.primaryImage.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(product.primaryImage),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.white.withOpacity(0.05),
              ),
              child: product.primaryImage.isEmpty
                  ? const Icon(Icons.checkroom_rounded,
                      color: Colors.white24, size: 32)
                  : null,
            ),
            const SizedBox(width: 12),
            // Name & price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _saveResult,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _shareResult,
            icon: const Icon(Icons.share),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentCyan,
            ),
          ),
          ElevatedButton.icon(
            onPressed: _downloadResult,
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentPink,
            ),
          ),
        ],
      ),
    );
  }

  void _saveResult() {
    // TODO: integrate with storage service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Result saved to gallery')),
    );
  }

  void _shareResult() {
    // TODO: integrate sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share dialog opened')),
    );
  }

  void _downloadResult() {
    // Alias for save – could implement file download
    _saveResult();
  }

  void _onNavTap(int index) {
    // Bottom navigation handling similar to HomeScreen
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/wishlist');
    } else if (index == 2) {
      // Already on Try‑On flow – maybe restart
      Navigator.pushNamed(context, '/camera');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    }
  }
}

// ------------------------------------------------------------
// Re‑usable glass card used in this screen (simple version)
// ------------------------------------------------------------
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(8)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}
