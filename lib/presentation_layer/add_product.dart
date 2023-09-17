import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/presentation_layer/main.dart';
import 'package:flutter_one/presentation_layer/registration_page.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../domain_layer/product.dart';

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
      scaffoldBackgroundColor: AppColors.background,
    ),
    home: Scaffold (
      appBar: AppBar(
        title: Text('Добавление товара'),
          backgroundColor: AppColors.main_font_color,
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
                color: AppColors.items_back,
                  boxShadow: [
                  BoxShadow(
                    color: AppColors.shadows,
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
                      backgroundColor: AppColors.light_color,
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
                        hintStyle: TextStyle(color: AppColors.main_font_color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.main_font_color),
                        ),
                      ),
                      cursorColor: AppColors.main_font_color,
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
                          hintStyle: TextStyle(color: AppColors.main_font_color),
                          focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.main_font_color),
                        ),
                      ),
                      cursorColor: AppColors.light_color,
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
                        hintStyle: TextStyle(color: AppColors.main_font_color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.main_font_color),
                        ),
                      ),
                      cursorColor: AppColors.light_color,
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        addProductToList();
                      },
                      child: Text(
                        'Добавить',
                        style: TextStyle(
                          color: AppColors.main_font_color,
                          fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        shadowColor: AppColors.main_font_color,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        backgroundColor:
                        AppColors.light_color,
                        minimumSize: Size(50, 50),
                      ),
                    ),
                  ],
                ),
              ),
          ),
          ),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
    ),
  );
  }
  Container bottomNavigationBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.light_color.withOpacity(0.25),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationPage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.account_circle,
                color: AppColors.light_color,
                size: 35,
              )
          ),
          IconButton(
              enableFeedback: false,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: const Icon(
                Icons.store,
                color: AppColors.light_color,
                size: 35,
              )
          ),
        ],
      ),
    );
  }
}