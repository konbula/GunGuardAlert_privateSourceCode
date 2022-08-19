import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/news/components/body.dart';
import 'package:guntrackattempt1/screens/news/components/recent_tab.dart';
import 'package:guntrackattempt1/service/recent_api_service.dart';

import '../../models/article_model.dart';

class newsScreen extends StatefulWidget {
  const newsScreen({Key? key}) : super(key: key);

  @override
  State<newsScreen> createState() => _newsScreenState();
}

class _newsScreenState extends State<newsScreen> {
  ApiService client = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(69, 157, 200, 245), body: Body());
  }
}
