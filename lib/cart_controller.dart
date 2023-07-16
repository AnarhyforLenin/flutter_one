import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter_one/product.dart';

class CartController extends GetxController {
  RxMap<Product, int> _products = <Product, int>{}.obs;


  RxMap<Product, int> get products => _products;

  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] = (_products[product] ?? 0) + 1;
    } else {
      _products[product] = 1;
    }

  }

  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product] == 1) {
      _products.removeWhere((key, value) => key == product);
    } else {
      _products[product] = _products[product]! - 1;
    }
  }

  void updateList() {
    _products.refresh();
  }

  String deleteProduct(Product product) {
      _products.removeWhere((key, value) => key == product);
      return '0';
  }


  get total => _products.isEmpty ? 0 : _products.entries.map((product) => product.key.price * product.value).toList()
      .reduce((value, element) => value + element);

}
