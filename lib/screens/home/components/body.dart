import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:guntrackattempt1/screens/home/components/profile_popup.dart';
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
  String initials = "2";
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
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(child: homeSearchBar()),
                              profile_popup(
                                  menulist: [
                                    //make the profile be able to drop down to reveal more info
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text("Profile"),
                                    )),
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.label_rounded),
                                      title: Text("Learn More"),
                                    )),
                                    PopupMenuDivider(),
                                    PopupMenuItem(
                                        child: ListTile(
                                      leading: Icon(Icons.info),
                                      title: Text("About"),
                                    )),
                                  ],
                                  icon: (initials == "")
                                      ? CircleAvatar(
                                          backgroundColor:
                                              Colors.brown.shade800,
                                          child: Icon(Icons.person),
                                        )
                                      : CircleAvatar(
                                          backgroundColor:
                                              Colors.brown.shade800,
                                          child: const Text("BK"),
                                        ))
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
