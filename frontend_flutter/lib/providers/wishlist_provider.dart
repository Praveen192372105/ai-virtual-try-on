// ============================================================
// wishlist_provider.dart — Wishlist / Favorites State
// ============================================================
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => List.unmodifiable(_items);
  int                get count => _items.length;

  bool isWishlisted(String productId) =>
      _items.any((p) => p.id == productId);

  void toggle(ProductModel product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
