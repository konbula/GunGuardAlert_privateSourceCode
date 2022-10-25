import 'package:flutter/material.dart';
import 'package:guntrackattempt1/providers/address_provider.dart';
import 'package:guntrackattempt1/routes.dart';
import 'package:guntrackattempt1/screens/nav/nav_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => addressChange())],
      child: MyApp(),
    ),
  );
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
