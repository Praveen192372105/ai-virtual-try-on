// ============================================================
// product_screen.dart — Product Detail Screen (Stub)
// ============================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../themes/app_theme.dart';
import 'tryon_screen.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductProvider>().selected;
    if (product == null) return const Scaffold(body: Center(child: Text('No product selected')));

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: AppTheme.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: product.primaryImage.isNotEmpty
                  ? Image.network(product.primaryImage, fit: BoxFit.cover)
                  : Container(color: AppTheme.cardDark,
                      child: const Icon(Icons.checkroom_rounded, size: 100, color: Colors.white24)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.accentCyan)),
                const SizedBox(height: 12),
                Text(product.description, style: const TextStyle(color: Colors.white60, fontSize: 15, height: 1.6)),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, TryOnScreen.routeName),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Try On'),
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.read<CartProvider>().addItem(product),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text('Add to Cart'),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
