import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  MyListItem({required this.name, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFf39189),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFbb8082),
              blurRadius: 4,
              offset: Offset(4, 8), // Shadow position
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                style: TextStyle(fontSize: 15, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 150,
              height: 150,
              child: Image.asset(
                imageUrl,
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
    );
  }
}