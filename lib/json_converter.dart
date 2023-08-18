import 'dart:convert';
import 'package:flutter_one/product.dart';
import 'package:flutter/services.dart' as rootBundle;

class JsonConverter {
  Future<List<Product>> ReadJsonData() async {
    final jsondata = await rootBundle.rootBundle.loadString('assets/json/products.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => Product.fromJson(e)).toList();
  }

  List<Map<String, dynamic>> WriteJsonData(List<Product> products) {
    return products.map((product) => product.toJson()).toList();
  }
}