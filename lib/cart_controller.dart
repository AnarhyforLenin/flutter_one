import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter_one/main.dart';

class CartController extends GetxController {
  RxMap<int, int> _products = <int, int>{}.obs;
  RxMap<int, int> get products => _products;

  Future<void> saveCartToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartList = [];
    for (var entry in _products.entries) {
      int productId = entry.key;
      int quantity = entry.value;

      String cartItem = '$productId:$quantity';
      cartList.add(cartItem);
    }
    print(cartList);
    await prefs.setStringList('cart', cartList);
  }

  Future<void> getCartFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartList = prefs.getStringList('cart');
    if (cartList != null) {

      for (String cartItem in cartList) {
        List<String> cartItemData = cartItem.split(':');
        int productId = int.tryParse(cartItemData[0]) ?? 0;
        int quantity = int.tryParse(cartItemData[1]) ?? 0;
        for (int i = 0; i < quantity; i++) {
          addProduct(productId);
        }
      }
    }
  }

  Product? getProductById(int id) {
    return Products.firstWhere((product) => product.id == id);
  }


  void addProduct(int productId) {
    _products.update(productId, (value) => value + 1, ifAbsent: () => 1);
    saveCartToSharedPreferences();
  }

  void removeProduct(int productId) {
    if (_products.containsKey(productId) && _products[productId]! == 1) {
      _products.remove(productId);
    } else if (_products.containsKey(productId)) {
      _products[productId] = _products[productId]! - 1;
    }
    saveCartToSharedPreferences();
  }

  void updateList() {
    _products.refresh();
  }

  void deleteProduct(int productId) {
      _products.removeWhere((key, value) => key == productId);
      saveCartToSharedPreferences();
  }

  double get total => _products.isEmpty
      ? 0
      : _products.entries
      .fold(0, (total, entry) {
    int productId = entry.key;
    int quantity = entry.value;
    Product? product = getProductById(productId);
    if (product != null) {
      return total + (product.price * quantity);
    }
    return total;
  });


}
