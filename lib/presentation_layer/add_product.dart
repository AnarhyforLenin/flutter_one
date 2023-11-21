import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_one/data_layer/data_base.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../domain_layer/cart_controller.dart';
import 'nav.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

  class _AddProductState extends State<AddProduct> {

  String product_name = '';
  int product_price = 0;
  String product_description = '';
  File? _image;

  final imagePicker = ImagePicker();

  final CartController cartController = Get.put(CartController());

  Future getImage() async {
  final image = await imagePicker.pickImage(source: ImageSource.gallery);
  setState(() {
    _image = File(image!.path);
  });
  }

  void addProductToList(String product_name, int product_price, String product_description, File image) {
      DataBase().addNewProductToDataBase(product_name, image.path, product_price, product_description);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Nav(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: AppColors.background,
    ),
    home: Scaffold (
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Добавление товара'),
          backgroundColor: AppColors.background,
          centerTitle: true,
        ),
        body:  WillPopScope(
          onWillPop: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Nav(),
              ),
            );
            return Future.value(false);
          },
          child: Padding (
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
                          product_name = value;
                        });
                      },
                      textInputAction: TextInputAction.next,
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        setState(() {
                          product_price = int.parse(value);;
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
                          product_description = value;
                        });
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Описание',
                        hintStyle: TextStyle(color: AppColors.main_font_color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.main_font_color),
                        ),
                      ),
                      cursorColor: AppColors.light_color,
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        if (product_name.isNotEmpty &&
                            product_price > 0 &&
                            product_description.isNotEmpty && _image != null) {
                          addProductToList(product_name, product_price, product_description, _image!);
                        }
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
    )
    ),
  );
  }
  void showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: TextStyle(color: AppColors.white)),
            duration: const Duration(seconds: 3),
          ),
        ));
  }
}