import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_one/product.dart';

class CartController extends GetxController {
  RxMap<Product, int> _products = <Product, int>{}.obs;


  RxMap<Product, int> get products => _products;


  Future<void> saveCartToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartList = [];
    for (var entry in _products.entries) {
      String productName = entry.key.name;
      int quantity = entry.value;

      String cartItem = '$productName:$quantity';
      cartList.add(cartItem);
    }
    await prefs.setStringList('cart', cartList);
  }

  Future<void> getCartFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cart');

    if (cartList != null) {
      Map<String, int> cartData = {};

      for (String cartItem in cartList) {
        List<String> cartItemData = cartItem.split(':');
        if (cartItemData.length == 2) {
          String productName = cartItemData[0];
          int quantity = int.tryParse(cartItemData[1]) ?? 0;
          cartData[productName] = quantity;
        }
      }
    }
  }


  void addProduct(Product product) {
    if (_products.containsKey(product)) {
      _products[product] = (_products[product] ?? 0) + 1;
    } else {
      _products[product] = 1;
    }
    saveCartToSharedPreferences();
  }

  void removeProduct(Product product) {
    if (_products.containsKey(product) && _products[product]! == 1) {
      _products.removeWhere((key, value) => key == product);
    } else {
      _products[product] = _products[product]! - 1;
    }
    saveCartToSharedPreferences();
  }

  void updateList() {
    _products.refresh();
  }

  void deleteProduct(Product product) {
      _products.removeWhere((key, value) => key == product);
      saveCartToSharedPreferences();
  }

  get total => _products.isEmpty ? 0 : _products.entries.map((product) => product.key.price * product.value).toList()
      .reduce((value, element) => value + element);

}
