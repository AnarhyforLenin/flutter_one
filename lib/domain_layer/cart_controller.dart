import 'package:flutter_one/domain_layer/product.dart';
import 'package:get/get.dart';
import 'package:flutter_one/domain_layer/cart_product_entity.dart';
import 'package:flutter_one/data_layer/data_base.dart';
class CartController extends GetxController {
  RxMap<int, int> _cartProducts = <int, int>{}.obs;
  RxMap<int, int> get cartProducts => _cartProducts;

  List<Product> _products = [];
  List<Product> get products => _products;

  set products(List<Product> value) {
    _products = value;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> loadData() async {
    List<CartProductEntity> dataCart = await DataBase().products();
    _cartProducts = convertToCart(dataCart);
  }

  Future<List<Product>> loadProducts() async {
    List<Product> dataProducts = await DataBase().getProductList();

    return dataProducts;
  }

  RxMap<int, int> convertToCart(List<CartProductEntity> cartProducts) {
    final rxMap = <int, int>{}.obs;

    for (final cartProduct in cartProducts) {
      rxMap[cartProduct.productId!] = cartProduct.quantity!;
    }

    return rxMap;
  }


  Product? getProductById(int id) {
    return products.firstWhere((product) => product.id == id);
  }

  Product? getProductByCartEntity(CartProductEntity cartProductEntity) {
    return products.firstWhere((product) => product.id == cartProductEntity.productId);
  }

  void addProduct(int productId) async {
    _cartProducts.update(productId, (quantity) => quantity + 1, ifAbsent: () => 1);
    CartProductEntity cartProductEntity = CartProductEntity(productId: productId,
        quantity: _cartProducts[productId]);
    if (await DataBase().hasProducts(productId)) {
      DataBase().insertProductIntoCart(cartProductEntity);
    } else {
      DataBase().updateProduct(cartProductEntity);
    }
  }

  void removeProduct(int productId) {
    if (_cartProducts.containsKey(productId) && _cartProducts[productId]! < 2) {
      _cartProducts.remove(productId);
      DataBase().deleteProduct(productId);
    } else if (_cartProducts.containsKey(productId)) {
      _cartProducts[productId] = _cartProducts[productId]! - 1;
      DataBase().updateProduct(CartProductEntity(productId: productId,
          quantity: _cartProducts[productId]));
    }
  }

  void removeAll() {
    for (var key in _cartProducts.keys.toList()) {
      DataBase().deleteProduct(key);
      _cartProducts.remove(key);
    }
  }

  void updateList() {
    _cartProducts.refresh();
  }

  void deleteProduct(int productId) {
      _cartProducts.removeWhere((key, value) => key == productId);
      DataBase().deleteProduct(productId);
  }

  double get total => _cartProducts.isEmpty
      ? 0
      : _cartProducts.entries
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
