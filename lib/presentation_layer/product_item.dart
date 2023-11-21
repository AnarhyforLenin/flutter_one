import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_one/data_layer/session.dart';
import 'package:get/get.dart';
import 'package:flutter_one/presentation_layer/custom_alert_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../domain_layer/cart_controller.dart';
import '../domain_layer/custom_image_widget.dart';
import '../domain_layer/product.dart';

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
    final int price = widget.product.price!;


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  child: AutoSizeText(
                      widget.product.name!,
                      style: TextStyle(fontSize: 15, color: AppColors.main_font_color),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                  ),
                  ),
                ),
              Container(
                alignment: Alignment.center,
                width: 150,
                height: 150,
                child: CustomImageWidget(
                  product: widget.product,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Text(
                          'Цена: $price €',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      !(widget.cartController.cartProducts[widget.product.id] == null || widget.cartController.cartProducts[widget.product.id] == 0)
                          ? Container(
                        width: 200,
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(child:
                            IconButton(
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
                                setState(() {
                                  widget.cartController.removeProduct(widget.product.id!);
                                  if (widget.cartController.cartProducts[widget.product.id] == 0 || widget.cartController.cartProducts[widget.product.id] == null) {
                                    widget.addedToCart = false;
                                    showBuyButton = true;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove_circle),
                              iconSize: 24,
                            ),
                            ),
                            Obx(() => FittedBox (
                              fit: BoxFit.contain,
                              child: Text(
                                '${widget.cartController.cartProducts[widget.product.id] ?? 0}',
                                style: TextStyle(fontSize: 15),
                              ),),
                            ),
                            Expanded(child:
                            IconButton(
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
                                setState(() {
                                  widget.cartController.addProduct(widget.product.id!);
                                });
                              },
                              icon: Icon(Icons.add_circle),
                              iconSize: 24,
                            ),
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
                                widget.cartController.addProduct(widget.product.id!);
                                setState(() {
                                  widget.addedToCart = true;
                                  showBuyButton = false;
                                });
                                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Товар добавлен', style: TextStyle(color: AppColors.main_font_color),),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: AppColors.light_color,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height * 0.83,
                                    ),
                                ),
                                );
                              },
                              child: Text(
                                'Купить',
                                style: TextStyle(
                                    color: AppColors.main_font_color),
                              ),
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                backgroundColor:
                                AppColors.light_color,
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




