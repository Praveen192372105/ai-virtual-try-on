// ============================================================
// product_details_screen.dart — Product Details View
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Detailed product page with image preview, description, price, and actions.
//   Supports "Add to Cart", "Try On", and wishlist toggling.
//   Follows the modern dark glassmorphism theme and Material 3 guidelines.
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../themes/app_theme.dart';
import 'upload_photo_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = '/product-details';
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // initialise favorite state from provider if needed
    final wishlist = context.read<WishlistProvider>();
    _isFavorite = wishlist.isWishlisted(widget.product.id);
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    final wishlist = context.read<WishlistProvider>();
    wishlist.toggle(widget.product);
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to cart'),
        backgroundColor: AppTheme.accentCyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _startTryOn() {
    // Navigate to upload photo screen; it will return the selected image path.
    Navigator.pushNamed(context, UploadPhotoScreen.routeName).then((photoPath) {
      if (photoPath != null) {
        // TODO: trigger try‑on API with product.id and photoPath
        // For now just show a placeholder dialog.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Try‑On started (placeholder)'),
            backgroundColor: AppTheme.primaryPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.product.name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? AppTheme.accentPink : Colors.white70,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Ambient glow background
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryPurple.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentCyan.withValues(alpha: 0.1),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: isLandscape ? _buildLandscapeContent() : _buildPortraitContent(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Portrait layout ────────────────────────────────────────
  Widget _buildPortraitContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageSection(),
          const SizedBox(height: 20),
          _buildInfoSection(),
          const SizedBox(height: 30),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // ── Landscape layout ───────────────────────────────────────
  Widget _buildLandscapeContent() {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildImageSection()),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoSection(),
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Image preview (with glassmorphic placeholder) ─────────────
  Widget _buildImageSection() {
    return Container(
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: widget.product.primaryImage.isNotEmpty
            ? Image.network(
                widget.product.primaryImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _imagePlaceholder(),
              )
            : _imagePlaceholder(),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple.withValues(alpha: 0.12),
            AppTheme.accentCyan.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.checkroom_rounded,
          color: Colors.white38,
          size: 64,
        ),
      ),
    );
  }

  // ── Textual product information ───────────────────────────────
  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          widget.product.category,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(color: AppTheme.accentCyan, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Text(
          widget.product.description,
          style: const TextStyle(color: Colors.white60, fontSize: 14),
        ),
      ],
    );
  }

  // ── Buttons: Add to Cart + Try On ───────────────────────────────
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _addToCart,
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            label: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _startTryOn,
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            label: const Text('Try On', style: TextStyle(color: Colors.white)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.primaryPurple.withValues(alpha: 0.6)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}
