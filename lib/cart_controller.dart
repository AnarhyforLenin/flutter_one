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

}
