import 'package:flutter/material.dart';
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
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

late bool nameSort;
String searchString = "";


List<Product> Products = [
  Product(id: 1, name: 'RedBull BeachBreeze', imageUrl: 'assets/images/beachbreeze.png', price: 20, description: 'Энергетик со вкусом бриза на пляже. В России не продается.'),
  Product(id: 2, name: 'RedBull Acai', imageUrl: 'assets/images/acai.png', price: 10, description: 'Энергетик с Асаи. В России не продается.'),
  Product(id: 3, name: 'RedBull Cactus', imageUrl: 'assets/images/cactus.png', price: 999, description: 'Энергетик со вкусом кактуса. В России не продается.'),
  Product(id: 4, name: 'RedBull Classic', imageUrl: 'assets/images/classic.png', price: 40, description: 'Энергетик RedBull классический. Есть в России и по всему миру.'),
  Product(id: 5, name: 'RedBull Coconut', imageUrl: 'assets/images/coconut.png', price: 50, description: 'Энергетик со вкусом кокоса и ягод. Есть по всему миру. Просто прекрасен.'),
  Product(id: 6, name: 'RedBull Grapefruit', imageUrl: 'assets/images/grapefruit.png', price: 60, description: 'Энергетик со вкусом грейпфрута. В России не продается.'),
  Product(id: 7, name: 'RedBull Kiwi&Apple', imageUrl: 'assets/images/kiwiapple.png', price: 70, description: 'Энергетик со вкусом киви и яблока. В России не продается.'),
  Product(id: 8, name: 'RedBull No Sugar', imageUrl: 'assets/images/nosugar.png', price: 80, description: 'Энергетик RedBull без сахара. Есть в России и по всему миру.'),
  Product(id: 9, name: 'RedBull Kratingdaeng', imageUrl: 'assets/images/small.png', price: 90, description: 'Энергетик странный и маленький. В России не продается.'),
  Product(id: 10, name: 'RedBull Tangerine', imageUrl: 'assets/images/tangerine.png', price: 150, description: 'Энергетик с тангарином. В России не продается.'),
  Product(id: 11, name: 'RedBull Watermalon', imageUrl: 'assets/images/watermelon.png', price: 110, description: 'Энергетик со вкусом арбуза. Есть в России и по всему миру.'),
];

class _HomePageState extends State<HomePage> {


  final CartController cartController = Get.put(CartController());

  Future<int> loadState () async {
    final prefs = await SharedPreferences.getInstance();
    final int state = prefs.getInt('firstValue') ?? 0;
    return state;
  }

  @override
  void initState() {
    super.initState();
    loadAndSortProducts();
  }

  Future<void> loadAndSortProducts() async {
    int state = await loadState();

    if (state == 0) {
      sortByName(false);
    } else if (state == 1) {
      sortByName(true);
    } else if (state == 2) {
      sortByPrice(false);
    } else if (state == 3) {
      sortByPrice(true);
    }
  }

  void sortByName(bool descendingNameUp) {
    setState(() {
      if (descendingNameUp) {
        Products.sort((a, b) => b.name.compareTo(a.name));
      } else {
        Products.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  void sortByPrice(bool descendingPriceUp) {
    setState(() {
      if (descendingPriceUp) {
        Products.sort((a, b) => b.price.compareTo(a.price));
      } else {
        Products.sort((a, b) => a.price.compareTo(b.price));
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
                      sortByName(descending);
                    } else {
                      sortByPrice(descending);
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
                child: IconButton(
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
              ),
            ),
            SizedBox(
              width: 10,
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
            child: ListView.builder(
              itemCount: Products.length,
              itemBuilder: (context, index) {
                return Products[index].name.toLowerCase().contains(searchString) ?
                  ProductItem(
                  product: Products[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetail(product: Products[index]),
                      ),
                    );
                  },
                  index: index,
                  cartController: cartController,
                  quantity: 1,
                  addedToCart: false,
                ) :
                    Container();
              },
            ),
          ),

        ],),

      ),
    );
  }
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
            nameSort = true;
            widget.sortCallback(dropdownValue.startsWith('Имя ↓'));
          } else if (isDescendingByPrice) {
            nameSort = false;
            widget.sortCallback(dropdownValue.startsWith('Цена ↓'));
          }
        });
      },
    );
  }
}

