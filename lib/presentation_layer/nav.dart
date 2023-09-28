import 'package:flutter/material.dart';
import 'package:flutter_one/presentation_layer/home_page.dart';
import 'package:flutter_one/presentation_layer/registration_page.dart';
import 'package:badges/badges.dart';
import '../utils/app_colors.dart';

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    RegistrationPage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                label: 'Registration',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            selectedFontSize: 15,
            selectedItemColor: AppColors.light_color,
            unselectedItemColor: AppColors.main_font_color,
            backgroundColor: AppColors.background,
          ),
    );
  }
}