import 'package:flutter/material.dart';

import 'components/body.dart';

class dataScreen extends StatefulWidget {
  static String routeName = "/data";
  @override
  State<dataScreen> createState() => _dataScreenState();
}

class _dataScreenState extends State<dataScreen> {
  int _currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(69, 157, 200, 245),
      body: Body(),
    );
  }
}
