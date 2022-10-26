import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/data/components/homocide_carousel.dart';
import 'package:guntrackattempt1/screens/data/components/mass_shooting_carousel.dart';
import 'package:guntrackattempt1/screens/data/components/search_bar.dart';
import 'package:guntrackattempt1/screens/data/components/suicide_carousel.dart';

import '../../data_tile/data_tile_screen.dart';

class DBody extends StatefulWidget {
  const DBody({Key? key}) : super(key: key);

  @override
  State<DBody> createState() => _DBodyState();
}

class _DBodyState extends State<DBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     left: 10.0,
          //     right: 10,
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(child: dataSearchBar()),
          //       CircleAvatar(
          //         backgroundColor: Colors.brown.shade800,
          //         child: const Text('AH'),
          //       )
          //     ],
          //   ),
          // ),
          homocideHeader(),
          homocideCarousel(),
          SizedBox(
            height: 40,
          ),
          MSHeader(),
          massShootingCarousel(),
          SizedBox(
            height: 40,
          ),
          suicideHeader(),
          suicideCarousel(),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
