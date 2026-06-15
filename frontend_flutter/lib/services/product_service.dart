// ============================================================
// product_service.dart — Product API Service
// ============================================================

import 'package:virtual_tryon_ai/services/api_service.dart';
import 'package:virtual_tryon_ai/services/api_constants.dart';

class ProductService {
  final ApiService _api = ApiService();

  /// Fetch a list of products, optionally filtered by [category] and [search] query.
  /// Returns a list of dynamic maps representing product data.
  Future<List<dynamic>> fetchProducts({String? category, String? search}) async {
    try {
      return await _api.getProducts(category: category, search: search);
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch detailed information for a specific product by its [productId].
  /// Returns a map containing product fields.
  Future<Map<String, dynamic>> fetchProductById(String productId) async {
    try {
      return await _api.getProductById(productId);
    } catch (e) {
      rethrow;
    }
  }
}
