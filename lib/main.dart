import 'package:flutter/material.dart';
import 'package:guntrackattempt1/routes.dart';
import 'package:guntrackattempt1/screens/home/home_screen.dart';
import 'package:guntrackattempt1/screens/nav/nav_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const NavScreen(),
      routes: routes,
    );
  }
}
