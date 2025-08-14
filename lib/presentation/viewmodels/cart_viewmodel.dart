import 'package:ecommerceapp/data/models/product.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final ProductModel product;
  int qty;
  CartItem(this.product, {this.qty = 1});
}

class CartViewModel extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  List<CartItem> get items => _items.values.toList();
  double get total =>
      _items.values.fold(0, (s, e) => s + e.product.price * e.qty);

  void add(ProductModel p) {
    _items.update(p.id, (c) {
      c.qty += 1;
      return c;
    }, ifAbsent: () => CartItem(p));
    notifyListeners();
  }

  void remove(ProductModel p) {
    _items.remove(p.id);
    notifyListeners();
  }

  void changeQty(ProductModel p, int qty) {
    if (qty <= 0) {
      remove(p);
      return;
    }
    final item = _items[p.id];
    if (item != null) {
      item.qty = qty;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
