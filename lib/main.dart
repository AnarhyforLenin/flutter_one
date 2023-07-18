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
  await Get.putAsync(() => SharedPreferences.getInstance());
  runApp(GetMaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  final List<Product> _products = [
    Product(name: 'RedBull Acai', price: 10, imageUrl: 'assets/images/acai.png', description: 'Энергетик с Асаи. В России не продается.'),
    Product(name: 'RedBull BeachBreeze', price: 20, imageUrl: 'assets/images/beachbreeze.png', description: 'Энергетик со вкусом бриза на пляже. В России не продается.'),
    Product(name: 'RedBull Cactus', price: 30, imageUrl: 'assets/images/cactus.png', description: 'Энергетик со вкусом кактуса. В России не продается.'),
    Product(name: 'RedBull Classic', price: 40, imageUrl: 'assets/images/classic.png', description: 'Энергетик RedBull классический. Есть в России и по всему миру.'),
    Product(name: 'RedBull Coconut', price: 50, imageUrl: 'assets/images/coconut.png', description: 'Энергетик со вкусом кокоса и ягод. Есть по всему миру. Просто прекрасен.'),
    Product(name: 'RedBull Grapefruit', price: 60, imageUrl: 'assets/images/grapefruit.png', description: 'Энергетик со вкусом грейпфрута. В России не продается.'),
    Product(name: 'RedBull Kiwi&Apple', price: 70, imageUrl: 'assets/images/kiwiapple.png', description: 'Энергетик со вкусом киви и яблока. В России не продается.'),
    Product(name: 'RedBull No Sugar', price: 80, imageUrl: 'assets/images/nosugar.png', description: 'Энергетик RedBull без сахара. Есть в России и по всему миру.'),
    Product(name: 'RedBull Kratingdaeng', price: 90, imageUrl: 'assets/images/small.png', description: 'Энергетик странный и маленький. В России не продается.'),
    Product(name: 'RedBull Tangerine', price: 100, imageUrl: 'assets/images/tangerine.png', description: 'Энергетик с тангарином. В России не продается.'),
    Product(name: 'RedBull Watermalon', price: 110, imageUrl: 'assets/images/watermelon.png', description: 'Энергетик со вкусом арбуза. Есть в России и по всему миру.'),
  ];

  final CartController cartController = Get.put(CartController());

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
              width: 30,
              child: DropdownWidget(),
            ),

          ),
          leadingWidth: 100,
          actions: [
            SizedBox(
              width: 45,
              height: 45,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShoppingCart()),
                    );
                  },
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.shopping_cart),
                  ),
                  backgroundColor: Color(0xFF6e7585),
                ),
              ),
            ),
            SizedBox(width: 10,),
          ],
          backgroundColor: Color(0xFF6e7582),
          centerTitle: true,
          title: Text(
            'Мое сердце остановилось',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15, // Установите желаемый размер текста здесь
              fontWeight: FontWeight.bold, // Установите желаемый начертание текста здесь
            ),
          ),
        ),

        body: ListView.builder(
          itemCount: _products.length,
          itemBuilder: (context, index) {
            return ProductItem(
              product: _products[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(product: _products[index]),
                  ),
                );
              },
              index: index,
              cartController: cartController,
              quantity: 1,
              addedToCart: false,
            );
          },
        ),
      ),
    );
  }

  void sortByName (List <Product> _products) {
    return _products.sort((a, b) => a.name.compareTo(b.name));
  }
}

class DropdownWidget extends StatefulWidget {
  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String dropdownvalue = 'Цена ↑';

  var items = [
    'Цена ↑',
    'Цена ↓',
    'Имя ↑',
    'Имя ↓',
  ];


  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropdownvalue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          dropdownvalue = newValue!;
        });
      },
    );
  }
}
