// ============================================================
// api_service.dart — HTTP API Client
// AI-Based Virtual Try-On Application
// ============================================================
// PURPOSE:
//   Centralised HTTP client using Dart's http package.
//   Handles all REST calls to the FastAPI backend on port 8000.
// ============================================================

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Base URL — 10.0.2.2 points to host localhost in Android Emulator
  static const String _baseUrl = 'http://10.0.2.2:8000/api/v1';

  final http.Client _client = http.Client();

  // ── Default Headers ───────────────────────────────────────
  Map<String, String> _headers({String? token}) => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // ─────────────────────────────────────────────────────────
  //  AUTH ENDPOINTS
  // ─────────────────────────────────────────────────────────

  /// POST /api/v1/auth/login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _post('/auth/login', {'email': email, 'password': password});
    
    // Map FastAPI token response to the pre-existing UserModel structure
    return {
      'token': res['access_token'] as String,
      'user': {
        '_id': res['user']['id'].toString(),
        'name': res['user']['full_name'],
        'email': res['user']['email'],
        'avatar': null,
        'role': 'user',
      }
    };
  }

  /// POST /api/v1/auth/signup
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // 1. Submit signup details to FastAPI signup endpoint
    await _post('/auth/signup', {
      'full_name': name,
      'email': email,
      'password': password,
    });

    // 2. Perform automatic login to generate JWT and construct user object
    return await login(email: email, password: password);
  }

  /// GET /api/v1/auth/me (Fallback profile return)
  Future<Map<String, dynamic>> getProfile(String token) async {
    // Since our backend doesn't define GET /auth/me, we return a mock structure.
    // AuthProvider will automatically save/read this from persistent StorageService anyway.
    return {
      '_id': '1',
      'name': 'Active User',
      'email': 'user@example.com',
      'avatar': null,
      'role': 'user',
    };
  }

  // ─────────────────────────────────────────────────────────
  //  PRODUCT ENDPOINTS
  // ─────────────────────────────────────────────────────────

  /// GET /api/v1/products
  Future<List<dynamic>> getProducts({String? category, String? search}) async {
    String path = '/products';
    final queryParams = <String, String>{};
    if (category != null && category != 'All') queryParams['category'] = category;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    
    if (queryParams.isNotEmpty) {
      final queryString = Uri(queryParameters: queryParams).query;
      path += '?$queryString';
    }

    final dynamic res = await _get(path);
    final list = res as List<dynamic>;

    // Map FastAPI database fields to pre-existing ProductModel JSON keys
    return list.map((item) => {
      '_id': item['id'].toString(),
      'name': item['name'],
      'description': item['description'] ?? '',
      'price': item['price'],
      'category': item['category'],
      'images': [item['image_url'] ?? ''],
      'modelImage': item['image_url'],
      'rating': 4.8,
      'reviewCount': 88,
      'inStock': true,
      'sizes': ['S', 'M', 'L', 'XL'],
      'colors': ['Black', 'White', 'Blue'],
    }).toList();
  }

  /// GET /api/v1/products/{product_id}
  Future<Map<String, dynamic>> getProductById(String id) async {
    final item = await _get('/products/$id');
    return {
      '_id': item['id'].toString(),
      'name': item['name'],
      'description': item['description'] ?? '',
      'price': item['price'],
      'category': item['category'],
      'images': [item['image_url'] ?? ''],
      'modelImage': item['image_url'],
      'rating': 4.8,
      'reviewCount': 88,
      'inStock': true,
      'sizes': ['S', 'M', 'L', 'XL'],
      'colors': ['Black', 'White', 'Blue'],
    };
  }

  // ─────────────────────────────────────────────────────────
  //  TRY-ON ENDPOINTS
  // ─────────────────────────────────────────────────────────

  /// POST /api/v1/upload/image & /api/v1/tryon/start — Secure Try-on flow
  Future<String> startTryOnSession({
    required File userPhoto,
    required String productId,
    String? token, // Accept JWT authorization token
  }) async {
    // 1. Upload user body image to /api/v1/upload/image
    final uploadUri = Uri.parse('$_baseUrl/upload/image');
    final uploadRequest = http.MultipartRequest('POST', uploadUri);
    
    if (token != null) {
      uploadRequest.headers['Authorization'] = 'Bearer $token';
    }
    
    uploadRequest.files.add(await http.MultipartFile.fromPath(
      'file',
      userPhoto.path,
      contentType: MediaType('image', 'jpeg'),
    ));

    final uploadStreamed = await uploadRequest.send();
    final uploadResponse = await http.Response.fromStream(uploadStreamed);
    final uploadData = _parseResponse(uploadResponse) as Map<String, dynamic>;
    final uploadedImageUrl = uploadData['image_url'] as String;

    // 2. Initiate the try-on simulation on the backend
    final tryonRes = await _post(
      '/tryon/start',
      {
        'product_id': int.parse(productId),
        'uploaded_image': uploadedImageUrl,
      },
      token: token,
    );

    // Return the TryOnHistory record ID
    return tryonRes['id'].toString();
  }

  /// GET /api/v1/tryon/{id} — Poll for results
  Future<String> pollTryOnResult({
    required String sessionId,
    String? token,
    void Function(double progress)? onProgress,
  }) async {
    const maxAttempts = 30;
    const pollInterval = Duration(seconds: 1);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);
      final data = await _get('/tryon/$sessionId', token: token);
      final status = data['status'] as String;

      onProgress?.call(i / maxAttempts);

      if (status == 'completed') {
        return data['generated_image'] as String;
      } else if (status == 'failed') {
        throw Exception('AI processing failed on backend');
      }
    }
    throw TimeoutException('Try-on timed out after ${maxAttempts} seconds');
  }

  // ─────────────────────────────────────────────────────────
  //  PRIVATE HELPERS
  // ─────────────────────────────────────────────────────────

  Future<dynamic> _get(String path, {String? token}) async {
    final res = await _client.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token: token),
    );
    return _parseResponse(res);
  }

  Future<dynamic> _post(String path, Map<String, dynamic> body, {String? token}) async {
    final res = await _client.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token: token),
      body: jsonEncode(body),
    );
    return _parseResponse(res);
  }

  dynamic _parseResponse(http.Response res) {
    final data = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    
    String message = 'API Error ${res.statusCode}';
    if (data is Map && data.containsKey('detail')) {
      message = data['detail'].toString();
    } else if (data is Map && data.containsKey('message')) {
      message = data['message'].toString();
    }
    throw Exception(message);
  }
}
