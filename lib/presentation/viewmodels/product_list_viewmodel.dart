import 'package:ecommerceapp/data/models/product.dart';
import 'package:ecommerceapp/data/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';

enum SortBy { priceAsc, priceDesc, nameAsc, popularityDesc }

class ProductListViewModel extends ChangeNotifier {
  final ProductRepository repo;
  ProductListViewModel(this.repo);

  List<ProductModel> _all = [];
  List<ProductModel> _visible = [];
  String _category = 'All';
  SortBy _sortBy = SortBy.popularityDesc;
  String _search = '';

  List<ProductModel> get products => _visible;
  String get category => _category;
  SortBy get sortBy => _sortBy;

  final List<String> categories = const [
    'All',
    'smartphones',
    'laptops',
    'fragrances',
    'groceries',
    'home-decoration',
    'tops',
    'womens-dresses',
    'womens-shoes',
    'mens-shirts',
    'mens-shoes',
    'mens-watches',
    'womens-watches',
    'womens-bags',
    'womens-jewellery',
    'sunglasses',
    'motorcycle',
  ];

  Future<void> load() async {
    if (_category == 'All') {
      _all = await repo.getProducts(category: 'All');
    } else {
      _all = await repo.getProducts(category: _category);
    }
    _apply();
  }

  void setCategory(String c) {
    _category = c;
    _apply();
  }

  void setSort(SortBy s) {
    _sortBy = s;
    _apply();
  }

  void setSearch(String s) {
    _search = s;
    _apply();
  }

  void addLocal(ProductModel p) {
    _all.add(p);
    _apply();
  }

  void _apply() {
    _visible =
        _all.where((p) {
          final catOk = _category == 'All' || p.category == _category;
          final searchOk =
              _search.isEmpty ||
              p.title.toLowerCase().contains(_search.toLowerCase());
          return catOk && searchOk;
        }).toList();

    switch (_sortBy) {
      case SortBy.priceAsc:
        _visible.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortBy.priceDesc:
        _visible.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortBy.nameAsc:
        _visible.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortBy.popularityDesc:
        _visible.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    notifyListeners();
  }
}
