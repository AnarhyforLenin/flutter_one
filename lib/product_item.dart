import 'package:flutter/material.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter_one/cart_controller.dart';

class ProductItem extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final int index;
  int quantity;
  final CartController cartController;
  bool addedToCart;

  ProductItem({
    required this.product,
    required this.onTap,
    required this.index,
    required this.cartController,
    required this.quantity,
    required this.addedToCart,
    Key? key,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();

}

class _ProductItemState extends State<ProductItem> {
  bool showBuyButton = true;


  @override
  Widget build(BuildContext context) {
    final int price = widget.product.price;


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 150,
                height: 150,
                child: Image.asset(
                  widget.product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          'Цена: $price €',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      !(widget.cartController.products[widget.product] == null || widget.cartController.products[widget.product] == 0)
                          ? Container(
                        width: 200,
                        height: 40,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                    widget.cartController
                                        .removeProduct(widget.product);
                                    if (widget.cartController.products[widget.product] == 0 || widget.cartController.products[widget.product] == null) {
                                      widget.addedToCart = false;
                                      showBuyButton = true;
                                      print(showBuyButton);
                                    }
                                });
                              },
                              icon: Icon(Icons.remove_circle),
                              iconSize: 24,
                            ),
                            Obx(() => Text('${widget.cartController.products[widget.product] ?? 0}',
                              style: TextStyle(fontSize: 15),
                            ),),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.cartController
                                      .addProduct(widget.product);
                                });
                              },
                              icon: Icon(Icons.add_circle),
                              iconSize: 24,
                            ),
                          ],
                        ),
                      )
                          : showBuyButton
                          ?
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () {
                                widget.cartController
                                    .addProduct(widget.product);
                                setState(() {
                                  widget.addedToCart = true;
                                  showBuyButton = false;
                                  print(showBuyButton);
                                });
                                Get.snackbar(
                                  "Товар добавлен",
                                  "Вы добавили ${widget.product.name} в корзину",
                                  snackPosition:
                                  SnackPosition.BOTTOM,
                                  duration: Duration(seconds: 1),
                                );
                              },
                              child: Text(
                                'Купить',
                                style: TextStyle(
                                    color: Colors.black),
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
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

