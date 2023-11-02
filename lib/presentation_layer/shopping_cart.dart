import 'package:flutter/material.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/presentation_layer/product_item.dart';
import 'package:get/get.dart';
import '../domain_layer/cart_controller.dart';
import '../domain_layer/product.dart';
import 'nav.dart';


class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> with TickerProviderStateMixin {
  final CartController cartController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Корзина', style: TextStyle(color: AppColors.main_font_color),),
        backgroundColor: AppColors.background,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.main_font_color,
        ),
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
      child: Column(
        children: [
          Expanded(child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              child: Container(
                width: 380,
                height: 650,
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
                child:
                Obx(() {
                  final products = cartController.products;
                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        'Корзина пуста',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      int productId = products.keys.elementAt(index);
                      Product? product = cartController.getProductById(productId);
                      if (product != null) {
                        return Dismissible(
                          key: Key(productId.toString()),
                          onDismissed: (direction) {
                            cartController.deleteProduct(productId);
                            cartController.updateList();
                          },
                          background: Container(color: Colors.red),
                          child: ProductItem(
                            product: product,
                            onTap: () {},
                            index: index,
                            cartController: cartController,
                            quantity: products[productId]!,
                            addedToCart: true,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );

                }),
              ),
            ),
          ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal:  20, vertical:  5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Итого',
                  style: TextStyle(
                    fontSize: 18, color: AppColors.main_font_color,
                  ), ),
                Obx(() => Text('${cartController.total}€',
                  style: TextStyle(
                    fontSize: 18, color: AppColors.main_font_color,),)
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Покупка завершена', style: TextStyle(color: AppColors.main_font_color),),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppColors.light_color,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.83,
                        ),
                      ),
                    );
                    cartController.removeAll();
                  },
                  child: Text(
                    'Купить',
                    style: TextStyle(
                        color: AppColors.main_font_color, fontSize: 15),
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
                    fixedSize: Size(125, 30),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
      ),
      );
  }
}
