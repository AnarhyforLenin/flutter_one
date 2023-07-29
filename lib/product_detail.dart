import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_one/main.dart';
import 'package:flutter_one/product.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find<CartController>();

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    final int price = product.price;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Color(0xFF6e7582),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            width: double.infinity,
            height: 575,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFf39189),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFbb8082),
                  blurRadius: 4,
                  offset: Offset(4, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(height: 30),
                Container(
                  height: 300,
                  width: 300,
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(height: 30),
                Text(
                  'Цена: $price €',
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                Container( height: 30),
                Text(
                product.description,
                  style: TextStyle(fontSize: 23),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  onPressed: () {
                    cartController.addProduct(product.id);
                    Get.snackbar(
                      "Товар добавлен",
                      "Вы добавили ${product.name} в корзину",
                      snackPosition:
                      SnackPosition.BOTTOM,
                      duration: Duration(seconds: 1),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Купить',
                    style: TextStyle(
                        color: Colors.black, fontSize: 20),
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
                    fixedSize: Size(170, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
