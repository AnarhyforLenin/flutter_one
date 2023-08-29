import 'package:flutter_one/session.dart';
import 'package:flutter_one/user_role.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter_one/cart_product_entity.dart';
import 'package:flutter_one/data_base.dart';
import 'package:flutter_one/json_converter.dart';

class CartController extends GetxController {
  RxMap<int, int> _products = <int, int>{}.obs;
  RxMap<int, int> get products => _products;

  List<Product> jsonProducts = [];
  final JsonConverter jsonConverter = JsonConverter();

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadProducts();
  }

  Future<void> loadData() async {
    List<CartProductEntity> dataCart = await DataBase().products();
    _products = convertToCart(dataCart);
  }

  RxMap<int, int> convertToCart(List<CartProductEntity> cartProducts) {
    final rxMap = <int, int>{}.obs;

    for (final cartProduct in cartProducts) {
      rxMap[cartProduct.productId!] = cartProduct.quantity!;
    }

    return rxMap;
  }
  
  Future<void> loadProducts() async {
    jsonProducts = await jsonConverter.ReadJsonData();
  }

  Product? getProductById(int id) {
    return jsonProducts.firstWhere((product) => product.id == id);
  }

  Product? getProductByCartEntity(CartProductEntity cartProductEntity) {
    return jsonProducts.firstWhere((product) => product.id == cartProductEntity.productId);
  }

  void addProduct(int productId) async {
    _products.update(productId, (quantity) => quantity + 1, ifAbsent: () => 1);

    CartProductEntity cartProductEntity = CartProductEntity(productId: productId,
        quantity: _products[productId]);

    if (await DataBase().hasProducts(productId)) {
      DataBase().insertProductIntoCart(cartProductEntity);
    } else {
      DataBase().updateProduct(cartProductEntity);
    }
  }

  void removeProduct(int productId) {
    if (_products.containsKey(productId) && _products[productId]! < 2) {
      _products.remove(productId);
      DataBase().deleteProduct(productId);
    } else if (_products.containsKey(productId)) {
      _products[productId] = _products[productId]! - 1;
      DataBase().updateProduct(CartProductEntity(productId: productId,
          quantity: _products[productId]));
    }
  }

  void removeAll() {
    for (var key in _products.keys.toList()) {
      DataBase().deleteProduct(key);
      _products.remove(key);
    }
  }

  void updateList() {
    _products.refresh();
  }

  void deleteProduct(int productId) {
      _products.removeWhere((key, value) => key == productId);
      DataBase().deleteProduct(productId);
  }

  double get total => _products.isEmpty
      ? 0
      : _products.entries
      .fold(0, (total, entry) {
    int productId = entry.key;
    int quantity = entry.value;
    Product? product = getProductById(productId);
    if (product != null) {
      return total + (product.price! * quantity);
    }
    return total;
  });


}
