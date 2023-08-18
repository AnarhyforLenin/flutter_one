import 'package:flutter/material.dart';
import 'package:flutter_one/json_converter.dart';
import 'package:flutter_one/product_detail.dart';
import 'package:flutter_one/product_item.dart';
import 'package:flutter_one/product.dart';
import 'package:flutter_one/shopping_cart.dart';
import 'package:flutter_one/cart_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

//void main() => runApp(GetMaterialApp(home: HomePage()));
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cartController = Get.put(CartController());

  await Get.putAsync(() => SharedPreferences.getInstance());
  await cartController.getCartFromSharedPreferences();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

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
    return state;
  }

  @override
  void initState() {
    super.initState();
    _loadAndSortProducts();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Мое сердце остановилось',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF6e7582),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: SizedBox(
              width: 100,
              child: Container(
                width: 100,
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
          leadingWidth: 100,
          actions: [
            SizedBox(
              width: 45,
              height: 45,
              child: FittedBox(
                child: Obx (() => Stack(
                  children: [
                    IconButton(
                      onPressed: () {
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
                      color: Color(0xff383b42),
                    ),
                    (cartController.products.length > 0) ?
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFf39189),
                        ),
                        child: Obx (() => Text(
                          cartController.products.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
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
          backgroundColor: Color(0xFF6e7582),
          centerTitle: true,
          title: Text(
            'Мое сердце остановилось',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(children: [
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
                hintStyle: TextStyle(color: Color(0xff383b42)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff383b42)),
                ),
                suffixIcon: Icon(Icons.search, color: Color(0xff383b42)),
              ),
                cursorColor: Color(0xff383b42),
            ),)

          ),
          Expanded(
              child: _productsListView(searchString.isEmpty ? jsonProducts : jsonProducts..where((product) => product.name.toString().toLowerCase().contains(searchString)).toList(),),
          ),
        ],),
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
    return DropdownButton(
      value: dropdownValue,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: Colors.white,
      ),
      dropdownColor: Colors.white,
      underline: Divider(
        color: Colors.white,
        thickness: 1,
      ),
      items: items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: TextStyle(color: Color(0xff27282d)),),
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

