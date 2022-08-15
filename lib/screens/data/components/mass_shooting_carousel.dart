import 'package:flutter/material.dart';
import 'package:guntrackattempt1/models/data_tile_models.dart';
import 'package:guntrackattempt1/screens/data_tile/data_tile_screen.dart';

class massShootingCarousel extends StatefulWidget {
  const massShootingCarousel({Key? key}) : super(key: key);

  @override
  State<massShootingCarousel> createState() => _massShootingCarouselState();
}

class _massShootingCarouselState extends State<massShootingCarousel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 270,
        //color: Colors.blue,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: MSDataTiles.length,
          itemBuilder: (BuildContext context, int index) {
            MSDataTile dataTile = MSDataTiles[index];
            double fontSizeChooser = 20;
            if (dataTile.title.length > 34) {
              fontSizeChooser = 15;
            }
            return GestureDetector(
              //   onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => DataTileScreen(dataTile: dataTile),
              //   ),
              // ),
              child: Container(
                width: 240,
                //color: Colors.red,
                margin: EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 180,
                        width: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  dataTile.title,
                                  style: TextStyle(
                                      fontSize: fontSizeChooser,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 1.2),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  dataTile.dateOf,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 116, 113, 113),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 160,
                      width: 220,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 59, 56, 56),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 3),
                                blurRadius: 6)
                          ]),
                      child: Container(//will hold the picture
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MSHeader extends StatelessWidget {
  const MSHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  'Mass Shootings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 15),
          )
        ],
      ),
    );
  }
}
