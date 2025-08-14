import 'dart:convert';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.brand,
    required this.price,
    required this.rating,
    required this.stock,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> j) => ProductModel(
    id: j['id'],
    title: j['title'] ?? '',
    description: j['description'] ?? '',
    category: j['category'] ?? '',
    brand: j['brand'] ?? '',
    price: (j['price'] as num?)?.toDouble() ?? 0,
    rating: (j['rating'] as num?)?.toDouble() ?? 0,
    stock: j['stock'] ?? 0,
    thumbnail: j['thumbnail'] ?? '',
    images: (j['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );

  static List<ProductModel> listFromResponse(String body) {
    final map = json.decode(body) as Map<String, dynamic>;
    final list = (map['products'] as List?) ?? [];
    return list.map((e) => ProductModel.fromJson(e)).toList();
  }
}
