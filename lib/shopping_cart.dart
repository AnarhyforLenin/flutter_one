import 'package:flutter/material.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter_one/product_item.dart';
import 'package:flutter_one/cart_controller.dart';
import 'package:get/get.dart';


class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> with TickerProviderStateMixin {
  final CartController cartController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6e7582),
      appBar: AppBar(
        title: Text('Корзина'),
        backgroundColor: Color(0xFF6e7582),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Container(
                width: 380,
                height: 650,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFE68573),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFbb8082),
                      blurRadius: 4,
                      offset: Offset(4, 8),
                    ),
                  ],
                ),
                child:
                Obx(() {
                  final products = cartController.products;
                  print(products);
                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        'Корзина пуста',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      int productId = products.keys.elementAt(index);
                      print(productId);
                      Product? product = cartController.getProductById(productId);
                      print(product);
                      if (product != null) {
                        return Dismissible(
                          key: Key(productId.toString()),
                          onDismissed: (direction) {
                            cartController.deleteProduct(productId);
                            cartController.updateList();
                          },
                          background: Container(color: Colors.red),
                          child: ProductItem(
                            product: product,
                            onTap: () {},
                            index: index,
                            cartController: cartController,
                            quantity: products[productId]!,
                            addedToCart: true,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );

                }),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal:  20, vertical:  5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Итого',
                  style: TextStyle(
                    fontSize: 18, color: Colors.black,
                  ), ),
                Obx(() => Text('${cartController.total}€',
                  style: TextStyle(
                    fontSize: 18, color: Colors.black,),)
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar(
                    "Покупка совершена!",
                    "Вы купили энергетиков на ${cartController.total}€",
                    snackPosition:
                    SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                  );
                    cartController.removeAll();
                  },
                  child: Text(
                    'Купить',
                    style: TextStyle(
                        color: Colors.black, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.black,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(20),
                    ),
                    backgroundColor:
                    Color(0xFF7D9295),
                    fixedSize: Size(125, 30),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),

      );
  }
}
