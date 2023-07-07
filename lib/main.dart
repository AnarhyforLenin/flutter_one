import 'package:flutter/material.dart';
import 'package:flutter_one/listview_item.dart';

void main() => runApp(HomePage());

class HomePage extends StatelessWidget {
  final List _items = [
    'RedBull Acai',
    'RedBull BeachBreeze',
    'RedBull Cactus',
    'RedBull Classic',
    'RedBull Coconut',
    'RedBull Grapefruit',
    'RedBull Kiwi&Apple',
    'RedBull No Sugar',
    'RedBull Kratingdaeng',
    'RedBull Tangerine',
    'RedBull Watermalon'
  ];
  final List<String> _imgList = [
    'assets/images/acai.png',
    'assets/images/beachbreeze.png',
    'assets/images/cactus.png',
    'assets/images/classic.png',
    'assets/images/coconut.png',
    'assets/images/grapefruit.png',
    'assets/images/kiwiapple.png',
    'assets/images/nosugar.png',
    'assets/images/small.png',
    'assets/images/tangerine.png',
    'assets/images/watermelon.png',
  ];
  final List _price = [
    '10',
    '20',
    '30',
    '40',
    '50',
    '60',
    '70',
    '80',
    '90',
    '100',
    '110'
  ];

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
          backgroundColor: Color(0xFF6e7582),
          centerTitle: true,
          title: Text(
            'Мое сердце остановилось',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return MyListItem(
              name: _items[index],
              price: _price[index],
              imageUrl: _imgList[index],
            );
          },
        ),
      ),
    );
  }
}
