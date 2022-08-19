import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guntrackattempt1/screens/home/components/search_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static const initialCameraPos = CameraPosition(
      target: LatLng(42.097070344947255, -87.72017223705998), zoom: 11.5);

  @override
  GoogleMapController? gmController;

  void dispose() {
    gmController?.dispose();
    super.dispose();
  }

  void addMarker(LatLng pos) {}
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
            panelBuilder: (sc) => PanelWidget(sc),
            //minHeight: 300,
            //maxHeight: 650,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            body: SafeArea(
              child: Expanded(
                child: Stack(children: [
                  Expanded(
                      child: GoogleMap(
                          initialCameraPosition: initialCameraPos,
                          mapType: MapType.normal,
                          onLongPress: addMarker,
                          onMapCreated: (controller) {
                            gmController = controller;
                          })),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: homeSearchBar()),
                              CircleAvatar(
                                backgroundColor: Colors.brown.shade800,
                                child: const Text('AH'),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: FloatingActionButton(
                                child: Text("CENTER!"),
                                onPressed: () => gmController?.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        initialCameraPos))),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            )));
  }
}

Widget PanelWidget(ScrollController sc) => ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      controller: sc,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 145, 143, 143),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(
          height: 36,
        ),
        //buildAboutText(),
        SizedBox(
          height: 24,
        ),
      ],
    );
