// ============================================================
// wishlist_screen.dart — Wishlist Screen
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../models/product_model.dart';
import '../widgets/glass_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../themes/app_theme.dart';

/// WishlistScreen displays all products saved by the user.
///
/// Features:
/// • Search bar to filter items.
/// • Responsive grid of product cards.
/// • Remove from wishlist button.
/// • "Try On" button to launch the try‑on flow.
/// • Empty‑state UI when the list is empty.
/// • Modern dark glassmorphic design using Material 3.
/// • Integrated bottom navigation bar.
class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = context.watch<WishlistProvider>();
    final List<ProductModel> allItems = wishlistProvider.items;
    final List<ProductModel> filtered = _search.isEmpty
        ? allItems
        : allItems
            .where((p) => p.name.toLowerCase().contains(_search))
            .toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search wishlist…',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.07),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => _search = v.toLowerCase()),
              ),
            ),
            // ── Content ──
            Expanded(
              child: filtered.isEmpty
                  ? _emptyState()
                  : _productGrid(filtered, wishlistProvider),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3), // 3 = Wishlist tab
    );
  }

  Widget _emptyState() {
    return Center(
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.favorite_border, size: 80, color: Colors.white70),
            SizedBox(height: 16),
            Text(
              'Your wishlist is empty',
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productGrid(List<ProductModel> items, WishlistProvider provider) {
    // Responsive column count based on screen width
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900
        ? 4
        : width > 600
            ? 3
            : 2;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final product = items[index];
        return _wishlistCard(product, provider);
      },
    );
  }

  Widget _wishlistCard(ProductModel product, WishlistProvider provider) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──
          AspectRatio(
            aspectRatio: 1,
            child: product.primaryImage.isNotEmpty
                ? Image.network(
                    product.primaryImage,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.white.withOpacity(0.05),
                    child: const Center(
                      child: Icon(Icons.checkroom_rounded,
                          color: Colors.white24, size: 48),
                    ),
          ),
          const SizedBox(height: 8),
          // ── Details ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppTheme.accentCyan, fontSize: 13),
                ),
              ],
            ),
          ),
          const Spacer(),
          // ── Action Buttons ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remove from wishlist
                IconButton(
                  tooltip: 'Remove from wishlist',
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  onPressed: () => provider.toggle(product),
                ),
                // Try‑On button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to camera screen with this product pre‑selected
                    Navigator.pushNamed(context, '/camera', arguments: product);
                  },
                  icon: const Icon(Icons.camera_alt, size: 16),
                  label: const Text('Try On', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
