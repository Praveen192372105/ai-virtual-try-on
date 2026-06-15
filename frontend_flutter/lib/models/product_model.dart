// ============================================================
// product_model.dart — Product Data Model
// ============================================================
class ProductModel {
  final String       id;
  final String       name;
  final String       description;
  final double       price;
  final String       category;
  final List<String> imageUrls;   // Multiple product images
  final String?      modelImageUrl; // Transparent PNG for try-on overlay
  final double       rating;
  final int          reviewCount;
  final bool         inStock;
  final List<String> sizes;
  final List<String> colors;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    this.modelImageUrl,
    this.rating     = 0.0,
    this.reviewCount = 0,
    this.inStock    = true,
    this.sizes      = const [],
    this.colors     = const [],
  });

  String get primaryImage => imageUrls.isNotEmpty ? imageUrls.first : '';

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id:             json['_id']           as String,
    name:           json['name']          as String,
    description:    json['description']   as String,
    price:          (json['price'] as num).toDouble(),
    category:       json['category']      as String,
    imageUrls:      List<String>.from(json['images'] ?? []),
    modelImageUrl:  json['modelImage']    as String?,
    rating:         (json['rating']  as num?)?.toDouble() ?? 0.0,
    reviewCount:    (json['reviewCount'] as int?) ?? 0,
    inStock:        (json['inStock']     as bool?) ?? true,
    sizes:          List<String>.from(json['sizes']  ?? []),
    colors:         List<String>.from(json['colors'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    '_id':         id,
    'name':        name,
    'description': description,
    'price':       price,
    'category':    category,
    'images':      imageUrls,
    'modelImage':  modelImageUrl,
    'rating':      rating,
    'reviewCount': reviewCount,
    'inStock':     inStock,
    'sizes':       sizes,
    'colors':      colors,
  };
}
