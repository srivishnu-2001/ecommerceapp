import 'package:http/http.dart' as http;

class ProductApiService {
  final http.Client _client;
  ProductApiService(this._client);

  // Array of all category URLs
  static const List<String> allCategoryUrls = [
    'https://dummyjson.com/products?limit=200',
    'https://dummyjson.com/products/category/smartphones?limit=200',
    'https://dummyjson.com/products/category/laptops?limit=200',
    'https://dummyjson.com/products/category/fragrances?limit=200',
    'https://dummyjson.com/products/category/groceries?limit=200',
    'https://dummyjson.com/products/category/home-decoration?limit=200',
    'https://dummyjson.com/products/category/skincare?limit=200',
    'https://dummyjson.com/products/category/tops?limit=200',
    'https://dummyjson.com/products/category/womens-dresses?limit=200',
    'https://dummyjson.com/products/category/womens-shoes?limit=200',
    'https://dummyjson.com/products/category/mens-shirts?limit=200',
    'https://dummyjson.com/products/category/mens-shoes?limit=200',
    'https://dummyjson.com/products/category/mens-watches?limit=200',
    'https://dummyjson.com/products/category/womens-watches?limit=200',
    'https://dummyjson.com/products/category/womens-bags?limit=200',
    'https://dummyjson.com/products/category/womens-jewellery?limit=200',
    'https://dummyjson.com/products/category/sunglasses?limit=200',
    'https://dummyjson.com/products/category/automotive?limit=200',
    'https://dummyjson.com/products/category/motorcycle?limit=200',
    'https://dummyjson.com/products/category/lighting?limit=200',
  ];

  Future<String> fetchFromUrl(String url) async {
    final uri = Uri.parse(url);
    final res = await _client.get(uri);
    if (res.statusCode == 200) return res.body;
    throw Exception('Failed to load products from $url');
  }
}
