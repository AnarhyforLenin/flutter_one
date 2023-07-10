import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    final String price = product.price;

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
            height: 500,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
