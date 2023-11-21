import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/presentation_layer/home_page.dart';
import 'package:flutter_one/data_layer/session.dart';
import 'package:get/get.dart';
import '../domain_layer/cart_controller.dart';
import '../domain_layer/custom_image_widget.dart';
import '../domain_layer/product.dart';
import 'custom_alert_dialog.dart';
import 'nav.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find<CartController>();

  ProductDetail({required this.product});

  @override
  Widget build(BuildContext context) {
    final int price = product.price!;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name!, style: TextStyle(color: AppColors.main_font_color),),
        backgroundColor: AppColors.items_back,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.main_font_color,
        ),
      ),
      backgroundColor: AppColors.background,
      body: WillPopScope(
    onWillPop: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => Nav(),
    ),
    );
    return Future.value(false);
    },
    child: Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            width: 380,
            height: double.infinity,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(height: 30),
                Container(
                  height: 300,
                  width: 300,
                  child: CustomImageWidget(
                    product: product,
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
                product.description!,
                  style: TextStyle(fontSize: 23),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  onPressed: () {
                    if (!Session.getInstance().isAuthenticated()) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  CustomAlertDialog(messageTitle: 'Войдите или зарегистрируйтесь',
                              messageContent: 'Выполните вход для совершения покупок', showSecondButton: true);
                        },
                      );
                      return;
                    }
                    cartController.addProduct(product.id!);
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
                        color: AppColors.main_font_color, fontSize: 20),
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
                    fixedSize: Size(170, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
