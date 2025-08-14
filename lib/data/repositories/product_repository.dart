import 'package:ecommerceapp/data/models/product.dart';
import 'package:http/http.dart' as http;

class ProductRepository {
  final ProductApiService api;
  final List<ProductModel> _localAdds = [];

  ProductRepository(this.api);

  // Fetch products for a specific category or all
  Future<List<ProductModel>> getProducts({String category = 'All'}) async {
    List<ProductModel> allProducts = [];

    if (category == 'All') {
      // Loop through all static URLs and combine results
      for (final url in ProductApiService.allCategoryUrls) {
        final body = await api.fetchFromUrl(url);
        allProducts.addAll(ProductModel.listFromResponse(body));
      }
    } else {
      // Replace spaces with '-' to match DummyJSON category format
      final formattedCategory = category.toLowerCase().replaceAll(' ', '-');
      final body = await api.fetchProductsByCategory(
        formattedCategory,
        limit: 200,
      );
      allProducts.addAll(ProductModel.listFromResponse(body));
    }

    return [...allProducts, ..._localAdds];
  }

  void addLocalProduct(ProductModel p) {
    _localAdds.add(p);
  }
}

class ProductApiService {
  final http.Client _client;
  ProductApiService(this._client);

  // Static URLs for all categories
  static const List<String> allCategoryUrls = [
    'https://dummyjson.com/products?limit=200', // All
    'https://dummyjson.com/products/category/smartphones?limit=200',
    'https://dummyjson.com/products/category/laptops?limit=200',
    'https://dummyjson.com/products/category/fragrances?limit=200',
    'https://dummyjson.com/products/category/groceries?limit=200',
    'https://dummyjson.com/products/category/home-decoration?limit=200',
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

  Future<String> fetchProducts({int limit = 200}) async {
    final uri = Uri.parse('https://dummyjson.com/products?limit=$limit');
    final res = await _client.get(uri);
    if (res.statusCode == 200) return res.body;
    throw Exception('Failed to load products');
  }

  Future<String> fetchProductsByCategory(
    String category, {
    int limit = 200,
  }) async {
    final uri = Uri.parse(
      'https://dummyjson.com/products/category/$category?limit=$limit',
    );
    final res = await _client.get(uri);
    if (res.statusCode == 200) return res.body;
    throw Exception('Failed to load category: $category');
  }

  Future<String> fetchFromUrl(String url) async {
    final uri = Uri.parse(url);
    final res = await _client.get(uri);
    if (res.statusCode == 200) return res.body;
    throw Exception('Failed to load products from $url');
  }
}
