import 'package:flutter/material.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter_one/product_item.dart';
import 'package:flutter_one/cart_controller.dart';
import 'package:get/get.dart';


class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
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
                      Product? product = cartController.getProductById(productId);
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
            padding: const EdgeInsets.symmetric(horizontal:  75, vertical:  15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Итого',
                  style: TextStyle(
                    fontSize: 25,
                  ),),
                Obx(() => Text('${cartController.total}€',
                  style: TextStyle(
                    fontSize: 25,),)
                ),
              ],
            ),
          ),

        ],
      ),

      );
  }
}
