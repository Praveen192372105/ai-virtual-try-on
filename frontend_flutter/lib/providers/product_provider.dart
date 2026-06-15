// ============================================================
// product_provider.dart — Product Catalog State Management
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Manages product listing, search, category filtering,
//   and individual product detail state.
// ============================================================

import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _api;

  // ── State ─────────────────────────────────────────────────
  List<ProductModel> _allItems      = [];
  List<ProductModel> _items         = [];
  ProductModel?      _selected;
  bool               _isLoading     = false;
  String?            _error;
  String             _searchQuery   = '';
  String             _activeCategory = 'All';

  // ── Getters ───────────────────────────────────────────────
  List<ProductModel> get items      => _items;
  ProductModel?      get selected   => _selected;
  bool               get isLoading  => _isLoading;
  String?            get error      => _error;

  ProductProvider(this._api);

  // ── Fetch All Products ────────────────────────────────────
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error     = null;
    notifyListeners();

    try {
      final data = await _api.getProducts();
      _allItems = data.map((j) => ProductModel.fromJson(j)).toList();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load products. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Filter by Category ────────────────────────────────────
  void filterByCategory(String category) {
    _activeCategory = category;
    _applyFilters();
  }

  // ── Search Products ───────────────────────────────────────
  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  // ── Select a Product for Detail View ─────────────────────
  void selectProduct(ProductModel product) {
    _selected = product;
    notifyListeners();
  }

  // ── Internal Filter Logic ─────────────────────────────────
  void _applyFilters() {
    _items = _allItems.where((p) {
      final matchesCategory = _activeCategory == 'All' ||
          p.category.toLowerCase() == _activeCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery) ||
          p.description.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }
}
