import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../home/home_screen.dart';
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
    return Scaffold(
      backgroundColor: Color.fromARGB(69, 157, 200, 245),
      body: Body(),
    );
  }
}
