import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/home/components/body.dart';
import 'package:guntrackattempt1/screens/data/components/search_bar.dart';
import 'package:guntrackattempt1/screens/data/data_screen.dart';

import '../../components/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollcont;
  @override
  void initState() {
    _scrollcont = ScrollController();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}
