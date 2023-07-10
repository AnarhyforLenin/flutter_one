import 'package:flutter/material.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter/gestures.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  ProductItem({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String price = product.price;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
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
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  product.name,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 150,
                height: 150,
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Цена: $price €',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
