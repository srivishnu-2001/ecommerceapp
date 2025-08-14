import 'package:ecommerceapp/data/models/product.dart';
import 'package:flutter/foundation.dart';

class ProductDetailViewModel extends ChangeNotifier {
  ProductModel? product;
  void setProduct(ProductModel p) {
    product = p;
    notifyListeners();
  }
}
