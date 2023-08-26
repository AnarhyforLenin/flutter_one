import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/product.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

  class _AddProductState extends State<AddProduct> {

  late String product_name;
  late String product_price;
  late String product_description;
  File? _image;

  final imagePicker = ImagePicker();

  Future getImage() async {
  final image = await imagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    _image = File(image!.path);
  });
  }

  void addProductToList() {
    if (product_name.isNotEmpty &&
    product_price.isNotEmpty &&
    product_description.isNotEmpty &&
    _image != null) {
      Product newProduct = Product(
        name: product_name,
        imageUrl: _image!.path,
        price: int.parse(product_price),
        description: product_description,
      );
      Get.back(result: newProduct);
    } else {
      Get.snackbar(
        "Введите данные",
        "Проверьте ввод названия, цены и опсания",
        snackPosition:
        SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Color(0xFF6e7582),
    ),
    home: Scaffold (
      appBar: AppBar(
        title: Text('Добавление товара'),
          backgroundColor: Color(0xFF6e7582),
          centerTitle: true,
        ),
        body: Padding (
          padding: EdgeInsets.all(5),
          child: Center(
            child: Container(
              width: double.infinity,
              height: 400,
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
              child: Padding (
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _image == null ?
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: FloatingActionButton(
                      onPressed: () {
                        getImage();
                      },
                      child: Icon(Icons.add_a_photo,
                        size: 40,),
                      backgroundColor: Color(0xFF49212b),
                      ),
                    ):
                    GestureDetector(
                      onTap: () {
                        getImage();
                      }, // Image tapped
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 150,
                        child: Image.file(_image!, fit: BoxFit.fill,),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          product_name = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Название продукта',
                        hintStyle: TextStyle(color: Color(0xff444850)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff444850)),
                        ),
                      ),
                      cursorColor: Color(0xff444850),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          product_price = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                          hintText: 'Цена',
                          hintStyle: TextStyle(color: Color(0xff444850)),
                          focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff444850)),
                        ),
                      ),
                      cursorColor: Color(0xff444850),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          product_description = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Описание',
                        hintStyle: TextStyle(color: Color(0xff444850)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff444850)),
                        ),
                      ),
                      cursorColor: Color(0xff444850),
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        addProductToList();
                      },
                      child: Text(
                        'Добавить',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18),
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
                        minimumSize: Size(50, 50),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          ),
      ),
    ),
  );
  }
}