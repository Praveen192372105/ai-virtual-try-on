// ============================================================
// cart_screen.dart — Shopping Cart Screen (Stub)
// ============================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(title: const Text('Cart (${0})'), backgroundColor: Colors.transparent),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: cart.items.isEmpty
            ? const Center(child: Text('Your cart is empty', style: TextStyle(color: Colors.white54)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cart.items.length,
                itemBuilder: (_, i) {
                  final item = cart.items[i];
                  return GlassCard(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      title: Text(item.product.name, style: const TextStyle(color: Colors.white)),
                      subtitle: Text('\$${item.product.price}', style: const TextStyle(color: AppTheme.accentCyan)),
                      trailing: Text('x${item.quantity}', style: const TextStyle(color: Colors.white70)),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Checkout — \$${cart.total.toStringAsFixed(2)}'),
        ),
      ),
    );
  }
}
