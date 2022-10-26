import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/news/components/legislation_tab.dart';
import 'package:guntrackattempt1/screens/news/components/news_search_bar.dart';
import 'package:guntrackattempt1/screens/news/components/recent_tab.dart';
import 'package:guntrackattempt1/screens/news/components/shootings_tab.dart';

class NBody extends StatefulWidget {
  const NBody({Key? key}) : super(key: key);

  @override
  State<NBody> createState() => _NBodyState();
}

class _NBodyState extends State<NBody> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController tabCont = TabController(length: 3, vsync: this);
    return SafeArea(
        child: Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 10.0, right: 15),
        //   child: Row(
        //     children: const [
        //       Expanded(child: newsSearchBar()),
        //       Icon(
        //         Icons.menu,
        //         size: 35,
        //       )
        //     ],
        //   ),
        // ),

        const SizedBox(
          height: 10,
        ),
        TabBar(labelColor: Colors.black, controller: tabCont, tabs: const [
          Tab(
            text: "Recent",
          ),
          Tab(
            text: "Legislation",
          ),
          Tab(
            text: "Shootings",
          )
        ]),
        Expanded(
          // width: MediaQuery.of(context).size.width,
          // height: double.infinity,
          child: TabBarView(controller: tabCont, children: [
            recent_tab(),
            legislation_tab(),
            shootings_tab(),
          ]),
        )
      ],
    ));
  }
}
