import 'package:flutter/material.dart';
import 'package:guntrackattempt1/routes.dart';

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _currentTab = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: pageList
              .asMap()
              .map((valueT, screen) => MapEntry(
                  valueT,
                  Offstage(
                    offstage: _currentTab != valueT,
                    child: screen,
                  )))
              .values
              .toList()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (int valueT) {
          setState(() {
            _currentTab = valueT;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ],
      ),
    );
  }
}
