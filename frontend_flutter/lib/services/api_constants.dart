// ============================================================
// api_constants.dart — API configuration constants
// ============================================================

class ApiConstants {
  // Base URL for the FastAPI backend API
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';

  // Product endpoints
  static const String products = '/products';
  static const String productDetails = '/products/'; // Append product ID
}
