import 'package:flutter/widgets.dart';
import 'package:guntrackattempt1/screens/data/data_screen.dart';
import 'package:guntrackattempt1/screens/home/home_screen.dart';
import 'package:guntrackattempt1/screens/news/news_screen.dart';

final Map<String, WidgetBuilder> routes = {
  dataScreen.routeName: (context) => dataScreen(),
  HomeScreen.routeName: (context) => HomeScreen()
};

final List<Widget> pageList = [dataScreen(), HomeScreen(), newsScreen()];
