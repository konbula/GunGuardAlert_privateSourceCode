import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/home/components/search_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SlidingUpPanel(
      panelBuilder: (sc) => PanelWidget(sc),
      minHeight: 300,
      maxHeight: 650,
      body: Row(
        children: const [
          homeSearchBar(),
        ],
      ),
    ));
  }
}

Widget PanelWidget(ScrollController sc) => ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: sc,
      children: <Widget>[
        SizedBox(
          height: 36,
        ),
        //buildAboutText(),
        SizedBox(
          height: 24,
        ),
      ],
    );
