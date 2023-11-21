import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/presentation_layer/product_detail.dart';
import 'package:flutter_one/presentation_layer/product_item.dart';
import 'package:flutter_one/data_layer/session.dart';
import 'package:flutter_one/presentation_layer/shopping_cart.dart';
import 'package:flutter_one/presentation_layer/custom_alert_dialog.dart';
import 'package:flutter_one/presentation_layer/add_product.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../domain_layer/cart_controller.dart';
import '../domain_layer/product.dart';
import '../domain_layer/user_role.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static bool nameSort = false;
  String searchString = "";

  Future<void> _loadProducts() async{
    cartController.products = await cartController.loadProducts();
  }

  final CartController cartController = Get.put(CartController());

  Future<int> _loadState () async {
    final prefs = await SharedPreferences.getInstance();
    final int state = prefs.getInt('firstValue') ?? 0;
    await cartController.loadData();
    await _loadProducts();
    return state;
  }

  @override
  void initState() {
    super.initState();
    startPage();
    _loadAndSortProducts();
  }

  void startPage() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Get.putAsync(() => SharedPreferences.getInstance());
  }

  Future<void> _loadAndSortProducts() async {
    int state = await _loadState();

    await _loadProducts();

    if (state == 0) {
      _sortByName(false);
    } else if (state == 1) {
      _sortByName(true);
    } else if (state == 2) {
      _sortByPrice(false);
    } else if (state == 3) {
      _sortByPrice(true);
    }
  }

  void _sortByName(bool descendingNameUp) {
    setState(() {
      if (descendingNameUp) {
        cartController.products.sort((a, b) => b.name!.compareTo(a.name!));
      } else {
        cartController.products.sort((a, b) => a.name!.compareTo(b.name!));
      }
    });
  }

  void _sortByPrice(bool descendingPriceUp) {
    setState(() {
      if (descendingPriceUp) {
        cartController.products.sort((a, b) => b.price!.compareTo(a.price!));
      } else {
        cartController.products.sort((a, b) => a.price!.compareTo(b.price!));
      }
    });
  }

  void deleteProduct(Product product) {
    cartController.deleteProductFromListOfProducts(product.id!);
    if (cartController.getProductById(product.id!) != null) {
      cartController.deleteProduct(product.id!);
      cartController.updateList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      return false;
    },
    child:  Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: AutoSizeText(
            'Мое сердце остановилось',
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.main_font_color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: SizedBox(
              width: 100,
              child: Container(
                width: 100,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: DropdownWidget(
                    sortCallback: (descending) {
                      if (nameSort) {
                        _sortByName(descending);
                      } else {
                        _sortByPrice(descending);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          leadingWidth: 100,
          actions: [
            SizedBox(
              width: 60,
              height: 60,
              child: FittedBox(
                child: Obx (() => Stack(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 20),
                    child: IconButton(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShoppingCart(),
                          ),
                        );
                      },
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(Icons.shopping_cart),
                      ),
                      color: AppColors.main_font_color,
                    ),),
                    (cartController.cartProducts.length > 0) ?
                    Positioned(
                      right: 20,
                      bottom: 4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.light_color,
                        ),
                        child: Obx (() => Text(
                          cartController.cartProducts.length.toString(),
                          style: TextStyle(
                            color: AppColors.main_font_color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),),
                      ),
                    ): Container(),
                  ],
                ),),

            ),
            ),
          ],
          backgroundColor: AppColors.background,
          centerTitle: true,
        ),
        body: Stack (
          children: [
            Column(children: [
              Padding(
                  padding: const EdgeInsets.all(7),
                  child: Container (
                    height: 40,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchString = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: searchString.isNotEmpty ? '' : 'Поиск',
                        hintStyle: TextStyle(color: AppColors.main_font_color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.main_font_color),
                        ),
                        suffixIcon: Icon(Icons.search, color: AppColors.main_font_color),
                      ),
                      cursorColor: AppColors.main_font_color,
                    ),)

              ),
              Expanded(
                child: _productsListView(searchString.isEmpty ? cartController.products : cartController.products.where((product) => product.name.toString().toLowerCase().contains(searchString)).toList(),),
              ),

            ],),
            Session.getInstance().getRole() == UserRole.admin ?
            Positioned(
              bottom: 50,
              right: 20,
              child:
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddProduct(),
                    ),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: AppColors.light_color,
              ),
            ): Container(),
          ],
        ),
    )
    );
  }

  Widget _productsListView(List<Product> products) => ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      if (Session.getInstance().getRole() == UserRole.admin && !(product.imageUrl!.startsWith('assets/'))) {
        return Dismissible(
          confirmDismiss: (DismissDirection direction) async {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Вы хотите удалить добавленный вами товар?', textAlign: TextAlign.center,),
                  content: Text('Это действие нельзя отменить, товар удалится из базы данных', textAlign: TextAlign.center,),
                  backgroundColor: AppColors.items_back,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  actions: <Widget>[
                    Center(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Да', style: TextStyle(color: AppColors.main_font_color, fontSize: 11,)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text('Нет', style: TextStyle(color: AppColors.main_font_color, fontSize: 11),),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
          key: Key(product.id.toString()),
          onDismissed: (direction) async {
            deleteProduct(product);
          },
          background: Container(color: Colors.red),
          child: ProductItem(
            product: product,
            onTap: () {},
            index: index,
            cartController: cartController,
            quantity: 1,
            addedToCart: true,
          ),
        );
      }
      return ProductItem(
        product: product,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetail(product: product),
            ),
          );
        },
        index: index,
        cartController: cartController,
        quantity: 1,
        addedToCart: false,
      );
    },
  );
}

class DropdownWidget extends StatefulWidget {
  final Function(bool) sortCallback;


  DropdownWidget({required this.sortCallback});

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  int dropdownValueIndex = 0;
  late String dropdownValue;

  final List<String> items = [
    'Имя ↑',
    'Имя ↓',
    'Цена ↑',
    'Цена ↓',
  ];

  _DropdownWidgetState() {
    dropdownValue = items[dropdownValueIndex];
  }

  bool get isDescendingByName => dropdownValue.startsWith('Имя');
  bool get isDescendingByPrice => dropdownValue.startsWith('Цена');

  @override
  void initState() {
    super.initState();
    loadState().then((value) {
      setState(() {
        dropdownValueIndex = value;
        dropdownValue = items[dropdownValueIndex];
      });
    });
  }

  void saveState () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('firstValue', dropdownValueIndex);
  }

  Future<int> loadState () async {
    final prefs = await SharedPreferences.getInstance();
    final int state = prefs.getInt('firstValue') ?? 0;
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding:
        EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.main_font_color),
        ),
      ),
      borderRadius: BorderRadius.circular(25)
          .copyWith(topLeft: Radius.circular(0)),
      value: dropdownValue,
      icon: FittedBox (
        fit: BoxFit.contain,
        child: Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.main_font_color,
        ),
      ),
      iconSize: 10,
      dropdownColor: AppColors.background,
      items: items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;
        return DropdownMenuItem(
          value: item,
          child: FittedBox (
            fit: BoxFit.contain,
            child: Text(item, style: TextStyle(color: AppColors.main_font_color, fontSize: 13),),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          dropdownValueIndex = items.indexOf(dropdownValue);
          saveState();
          if (isDescendingByName) {
            _HomePageState.nameSort = true;
            widget.sortCallback(dropdownValue.startsWith('Имя ↓'));
          } else if (isDescendingByPrice) {
            _HomePageState.nameSort = false;
            widget.sortCallback(dropdownValue.startsWith('Цена ↓'));
          }
        });
      },
    );
  }
}


