import 'package:ecommerceapp/data/models/product.dart';
import 'package:ecommerceapp/data/repositories/product_repository.dart';
import 'package:flutter/foundation.dart';

class AdminViewModel extends ChangeNotifier {
  final ProductRepository repo;
  int _tempId = 100000;

  AdminViewModel(this.repo);

  ProductModel createLocal({
    required String title,
    required double price,
    required String category,
    required String imageUrl,
  }) {
    final p = ProductModel(
      id: _tempId++,
      title: title,
      description: '',
      category: category,
      brand: 'Custom',
      price: price,
      rating: 5,
      stock: 100,
      thumbnail: imageUrl,
      images: [imageUrl],
    );
    repo.addLocalProduct(p);
    notifyListeners();
    return p;
  }
}
