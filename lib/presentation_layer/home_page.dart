import 'package:flutter/material.dart';
import 'package:flutter_one/utils/app_colors.dart';
import 'package:flutter_one/data_layer/json_converter.dart';
import 'package:flutter_one/presentation_layer/product_detail.dart';
import 'package:flutter_one/presentation_layer/product_item.dart';
import 'package:flutter_one/data_layer/session.dart';
import 'package:flutter_one/presentation_layer/shopping_cart.dart';
import 'package:flutter_one/presentation_layer/registration_page.dart';
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

  List<Product> jsonProducts = [];
  final JsonConverter jsonConverter = JsonConverter();

  Future<void> _loadProducts() async {
    jsonProducts = await jsonConverter.ReadJsonData();
  }

  final CartController cartController = Get.put(CartController());

  Future<int> _loadState () async {
    final prefs = await SharedPreferences.getInstance();
    final int state = prefs.getInt('firstValue') ?? 0;
    await cartController.loadData();
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
        jsonProducts.sort((a, b) => b.name!.compareTo(a.name!));
      } else {
        jsonProducts.sort((a, b) => a.name!.compareTo(b.name!));
      }
    });
  }

  void _sortByPrice(bool descendingPriceUp) {
    setState(() {
      if (descendingPriceUp) {
        jsonProducts.sort((a, b) => b.price!.compareTo(a.price!));
      } else {
        jsonProducts.sort((a, b) => a.price!.compareTo(b.price!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Мое сердце остановилось',
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
                    (cartController.products.length > 0) ?
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
                          cartController.products.length.toString(),
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
                child: _productsListView(searchString.isEmpty ? jsonProducts : jsonProducts.where((product) => product.name.toString().toLowerCase().contains(searchString)).toList(),),
              ),

            ],),
            Session.getInstance().getRole() == UserRole.admin ?
            Positioned(
              bottom: 70,
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
    );
  }

  Widget _productsListView(List<Product> products) => ListView.builder(
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];

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
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.main_font_color,
      ),
      iconSize: 13,
      dropdownColor: AppColors.background,
      items: items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(color: AppColors.main_font_color, fontSize: 15),),

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

