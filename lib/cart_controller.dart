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
    await DataBase.initDatabase();
    List<CartProductEntity> dataCart = await DataBase().products();
    _products = convertToCart(dataCart);
    await loadProducts();
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

  // Future<void> saveCartToSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String> cartList = [];
  //   for (var entry in _products.entries) {
  //     int productId = entry.key;
  //     int quantity = entry.value;
  //
  //     String cartItem = '$productId:$quantity';
  //     cartList.add(cartItem);
  //   }
  //   await prefs.setStringList('cart', cartList);
  // }
  //
  // Future<void> getCartFromSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? cartList = prefs.getStringList('cart');
  //   if (cartList != null) {
  //
  //     for (String cartItem in cartList) {
  //       List<String> cartItemData = cartItem.split(':');
  //       int productId = int.tryParse(cartItemData[0]) ?? 0;
  //       int quantity = int.tryParse(cartItemData[1]) ?? 0;
  //       _products[productId] = quantity;
  //     }
  //   }
  // }

  Product? getProductById(int id) {
    return jsonProducts.firstWhere((product) => product.id == id);
  }

  Product? getProductByCartEntity(CartProductEntity cartProductEntity) {
    return jsonProducts.firstWhere((product) => product.id == cartProductEntity.productId);
  }

  void addProduct(int productId) async {
    _products.update(productId, (quantity) => quantity + 1, ifAbsent: () => 1);

    List<CartProductEntity> cart = await DataBase().getEntityByProductId(productId);

    CartProductEntity cartProductEntity = CartProductEntity(productId: productId,
        quantity: _products[productId]);

    if (cart.isEmpty) {
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
