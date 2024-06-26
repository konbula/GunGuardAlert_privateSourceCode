import 'dart:async';
import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:guntrackattempt1/models/shooting_info_model.dart';
import 'package:guntrackattempt1/screens/home/components/aboutPage.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import "package:guntrackattempt1/providers/address_provider.dart";
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
//all other imports
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:guntrackattempt1/screens/home/components/profile.dart';
import 'package:guntrackattempt1/screens/home/components/profile_popup.dart';
import 'package:guntrackattempt1/screens/home/components/search_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Body extends StatefulWidget {
  static String HomeAddress = "3510 Lake Ave, Wilmette, IL 60091";

  @override
  State<Body> createState() => BodyState();
}

class BodyState extends State<Body> {
  String? title;

  void getWebsiteData(String rawHtml) async {
    dom.Document html = parser.parse(rawHtml);
    final title = html.querySelector('tbody')?.innerHtml.trim();

    setState(() {
      //This strips tags
      //this.title = _parseHtmlString(title);
      this.title = title;
    });
  }

  Splitter(String stringo) {
    var test = stringo.replaceAll(RegExp('\\<.*?\\>'), '<>');
    var result = test.split("<>");
    var finalResult = result
        .where((x) =>
            (x != "") &&
            (x != " ") &&
            (x != "\n") &&
            (x != "View Incident") &&
            (x != "View Source"))
        .toList();
    return finalResult;
    // return test;
  }

  WebViewController? wvController;
  // late List<shooting> hShootings = addShootings(Splitter(title ??
  //     '<>not workinng<><>not workinng<><>not workinng<><>not workinng<><>not workinng<><>not workinng<><>not workinng<>'));

  //start of google maps constructions and stuff

  final adressStoreController = TextEditingController();
  void dispose() {
    adressStoreController.dispose();
    reloadWebPagetimer?.cancel();
    super.dispose();
  }

// maps functions and variables

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    //to miles using 0.621371 conversion
    return 0.621371 * 12742 * asin(sqrt(a));
  }

  Future<List> convertAddressToLatLonList(List addresses) async {
    List convertedList = [];
    for (var address in addresses) {
      List<Location> locations = await locationFromAddress(
        address,
      );
      for (var x in locations) {
        convertedList.add([x.latitude, x.longitude]);
      }
    }
    return convertedList;
  }

  late Future blarg;

  List RealnewAdresses = ["3510 Lake Ave, Wilmette, IL 60091"];

  void ChangeRealnewAdresses(List newThing) {
    setState(() {
      RealnewAdresses = newThing;
    });
  }

  MapController? mapController;
  LatLng homePos = LatLng(42.07659479554499, -87.76737549957654);

  static bool isSafe = true;

  void initState() {
    blarg = convertAddressToLatLonList(RealnewAdresses);

    reloadWebPagetimer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      reloadWebView();
      print("reloaded");
      print(context.watch<addressChange>().getHomeAddress());
      // print(Body.HomeAddress);
      // print(homePos);
    });

    super.initState();
  }

  void safetyChange(List blah) async {
    int tick = 0;
    List safetyChangeDistance = await convertAddressToLatLonList(
        [context.watch<addressChange>().getHomeAddress()]);
    for (var i in blah) {
      List addressLocation = await convertAddressToLatLonList([i]);
      if (calculateDistance(
              safetyChangeDistance[0][0],
              safetyChangeDistance[0][1],
              addressLocation[0][0],
              safetyChangeDistance[0][1]) <=
          10) {
        print(calculateDistance(
            safetyChangeDistance[0][0],
            safetyChangeDistance[0][1],
            addressLocation[0][0],
            safetyChangeDistance[0][1]));
        tick += 1;
      }
    }
    if (tick > 0) {
      isSafe = false;
    } else {
      isSafe = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Offstage(
          offstage: true,
          child: WebView(
            initialUrl: "https://www.gunviolencearchive.org/last-72-hours",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: ((webController) async =>
                {wvController = webController}),
            onPageFinished: (_) async {
              final html = await wvController?.runJavascriptReturningResult(
                  'new XMLSerializer().serializeToString(document)');
              getWebsiteData(json.decode(html ?? ""));

              List newAdresses() {
                var b = addShootings(Splitter(title!));
                List finalList = [];
                for (var i = 0; i < b.length; i++) {
                  finalList.add(b[i].state +
                      " " +
                      b[i].cityOrCounty +
                      " " +
                      b[i].address);
                }
                return finalList;
              }

              ChangeRealnewAdresses(newAdresses());
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          shadowColor: Colors.black,
          bottomOpacity: 0.8,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image.asset(
              'assets/images/GunGuardAlert.png',
            ),
          ),
          leadingWidth: 500,
          backgroundColor: Colors.white,
          elevation: 0.0,
          //need leading
          actions: [
            profile_popup(
                menulist: [
                  //make the profile be able to drop down to reveal more info
                  PopupMenuItem(
                      child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profile"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => profilePage(),
                      ),
                    ),
                  )),

                  const PopupMenuDivider(),
                  PopupMenuItem(
                      child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AboutPage(),
                      ),
                    ),
                  )),
                ],
                icon: CircleAvatar(
                  backgroundColor: Colors.brown.shade800,
                  child: const Icon(Icons.person),
                ))
          ],
        ),
        body: SlidingUpPanel(
            header: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Colors.white,
              child: Center(
                child: Container(
                  height: 7,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            panelBuilder: (sc) => PanelWidget(sc),
            //minHeight: 300,
            //maxHeight: 650,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            body: SafeArea(
                child: (Stack(children: [
              title == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List>(
                      future: convertAddressToLatLonList(RealnewAdresses),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        // return Text(snapshot.data
                        //     .toString()
                        //     .replaceAll(RegExp("\\[", unicode: true), "")
                        //     .replaceAll(RegExp("\\]", unicode: true), "")
                        //     .replaceAll(",", "")
                        //     .split(" ")[1]);
                        print(homePos);
                        void homPosThing() async {
                          List a = await convertAddressToLatLonList([
                            context.watch<addressChange>().getHomeAddress()
                          ]);
                          homePos = LatLng(a[0][0], a[0][1]);
                        }

                        homPosThing();
                        print(homePos);

//trying something wierd here

                        List newAdresses() {
                          var b = addShootings(Splitter(title!));
                          List finalList = [];
                          for (var i = 0; i < b.length; i++) {
                            finalList.add(b[i].state +
                                " " +
                                b[i].cityOrCounty +
                                " " +
                                b[i].address);
                          }
                          return finalList;
                        }

                        safetyChange(newAdresses());

                        Future<List> convertedToLatLongList =
                            convertAddressToLatLonList(newAdresses());
                        List cheese = [];
                        void doSomething() async {
                          List blah = await convertedToLatLongList;
                          cheese.add(blah);
                        }

                        doSomething();

                        List<Marker> _getMarkers() {
                          List<Marker> markers = [];
                          //experiment

                          List blargList = snapshot.data
                              .toString()
                              .replaceAll(RegExp("\\[", unicode: true), "")
                              .replaceAll(RegExp("\\]", unicode: true), "")
                              .replaceAll(",", "")
                              .split(" ");

                          for (int x = 0; x < blargList.length; x++) {
                            if ((x % 2 == 0) &
                                (blargList.length > 1) &
                                blargList.length.isEven) {
                              markers.add(Marker(
                                  point: LatLng(double.parse(blargList[x]),
                                      double.parse(blargList[x + 1])),
                                  builder: ((context) => GestureDetector(
                                      onTap: (() async {
                                        int poo = (x / 2).round();

                                        var a = addShootings(Splitter(title!));
                                        shooting xShooting = a[poo];

                                        Uri url = Uri.parse(
                                            "https://gunviolencearchive.org/incident/" +
                                                xShooting.incidentID);

                                        await launchUrl(url,
                                            mode:
                                                LaunchMode.externalApplication);
                                      }),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: calculateDistance(
                                                      homePos.latitude,
                                                      homePos.longitude,
                                                      double.parse(
                                                          blargList[x]),
                                                      double.parse(
                                                          blargList[x + 1])) <=
                                                  10
                                              ? Colors.red
                                              : Colors.blue,
                                        ),
                                      )))));
                            }
                          }
                          return markers;
                        }

                        List<Marker> _getHomeMarker() {
                          List<Marker> markers = [];
                          markers.add(Marker(
                              point: homePos,
                              width: 60,
                              height: 60,
                              builder: ((context) => Icon(
                                    Icons.home,
                                    size: 60,
                                    color:
                                        isSafe ? Colors.blue : Colors.redAccent,
                                  ))));
                          return markers;
                        }

                        List<CircleMarker> homeCircle() {
                          List<CircleMarker> markers = [
                            CircleMarker(
                                point: homePos,
                                color: Colors.blue.withOpacity(0.3),
                                borderStrokeWidth: 3.0,
                                borderColor: Colors.blue,
                                radius: 100,
                                useRadiusInMeter: true)
                          ];

                          return markers;
                        }

                        List<Marker> _getAreaMarkers() {
                          if (homePos == null) {
                            return [];
                          }

                          return [
                            new Marker(
                              width: 230.0,
                              height: 230.0,
                              point: new LatLng(
                                  homePos.latitude, homePos.longitude),
                              builder: (ctx) => new Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.withOpacity(0.1),
                                    border:
                                        Border.all(color: Colors.blueAccent)),
                              ),
                            )
                          ];
                        }

                        //distance method

                        return Stack(children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                                center: homePos,
                                zoom: 11,
                                plugins: [MarkerClusterPlugin()],
                                maxZoom: 13,
                                minZoom: 4),
                            layers: [
                              TileLayerOptions(
                                minZoom: 1,
                                maxZoom: 13,
                                backgroundColor: Colors.black,
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              ),
                              MarkerLayerOptions(
                                markers: _getAreaMarkers(),
                              ),
                              CircleLayerOptions(circles: homeCircle()),
                              MarkerLayerOptions(
                                markers: _getMarkers(),
                              ),
                              MarkerLayerOptions(
                                markers: _getHomeMarker(),
                              ),
                              MarkerClusterLayerOptions(
                                maxClusterRadius: 10,
                                disableClusteringAtZoom: 16,
                                size: Size(50, 50),
                                fitBoundsOptions: FitBoundsOptions(
                                  padding: EdgeInsets.all(50),
                                ),
                                markers: _getMarkers(),
                                polygonOptions: PolygonOptions(
                                    borderColor: Colors.blueAccent,
                                    color: Colors.black12,
                                    borderStrokeWidth: 3),
                                builder: (context, markers) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle),
                                    child: Text('${markers.length}'),
                                  );
                                },
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: [
                                  // Row(
                                  //   children: [
                                  //     const Expanded(child: homeSearchBar()),
                                  //     profile_popup(
                                  //         menulist: [
                                  //           //make the profile be able to drop down to reveal more info
                                  //           PopupMenuItem(
                                  //               child: ListTile(
                                  //             leading: const Icon(Icons.person),
                                  //             title: const Text("Profile"),
                                  //             onTap: () => Navigator.push(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                 builder: (_) => profilePage(
                                  //                   initial: initials,
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           )),
                                  //           const PopupMenuItem(
                                  //               child: ListTile(
                                  //             leading:
                                  //                 Icon(Icons.label_rounded),
                                  //             title: Text("Learn More"),
                                  //           )),
                                  //           const PopupMenuDivider(),
                                  //           const PopupMenuItem(
                                  //               child: ListTile(
                                  //             leading: Icon(Icons.info),
                                  //             title: Text("About"),
                                  //           )),
                                  //         ],
                                  //         icon: (initials == "")
                                  //             ? CircleAvatar(
                                  //                 backgroundColor:
                                  //                     Colors.brown.shade800,
                                  //                 child:
                                  //                     const Icon(Icons.person),
                                  //               )
                                  //             : CircleAvatar(
                                  //                 backgroundColor:
                                  //                     Colors.brown.shade800,
                                  //                 child: const Text("BK"),
                                  //               ))
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ]);
                      }),
                    )
            ])))));
  }

  Timer? reloadWebPagetimer;
  void reloadWebView() {
    wvController?.reload();
  }

  Widget PanelWidget(ScrollController sc) => title == null
      ? const Center(child: CircularProgressIndicator())
      : ListView(controller: sc, children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(3.0),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Color.fromARGB(255, 86, 147, 253),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Text(
                          "STATUS",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 40,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 5,
                        width: 175,
                        color:
                            Color.fromARGB(255, 228, 220, 220).withOpacity(0.8),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      isSafe
                          ? Column(
                              children: [
                                Text(
                                  "SAFE",
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 30,
                                      letterSpacing: 5,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "There has been no confirmed firearm activity near you. Check back to see if the status has changed.",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 241, 239, 239),
                                        fontSize: 20),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text(
                                  "POSSIBLE DANGER",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 228, 28, 55),
                                      fontSize: 30,
                                      letterSpacing: 5,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "There has been confirmed firearm activity within 10 miles of you. Be prepared and keep a look out for any signs of danger.",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 241, 239, 239),
                                        fontSize: 20),
                                  ),
                                )
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
          //other things above
          Container(
            child: Column(
              children: [
                Text(
                  "Recent Activity",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.only(left: 18, bottom: 27),
            child: Text(
              "All data and information of markers is from The Gun Violence Archive public database.",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),

          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addShootings(Splitter(title!)).length,
                itemBuilder: (BuildContext context, int index) {
                  var a = addShootings(Splitter(title!));
                  shooting xShooting = a[index];
                  return GestureDetector(
                    onTap: () async {
                      Uri url = Uri.parse(
                          "https://gunviolencearchive.org/incident/" +
                              xShooting.incidentID);

                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, bottom: 10, top: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 5),
                                blurRadius: 5,
                                color: const Color.fromARGB(255, 67, 66, 66)
                                    .withOpacity(0.13),
                              )
                            ]),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Text(
                              xShooting.incidentDate,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              child: Text(
                                  "${xShooting.state}, ${xShooting.cityOrCounty}",
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      (xShooting.state + xShooting.cityOrCounty)
                                                  .length >
                                              20
                                          ? const TextStyle(fontSize: 15)
                                          : const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ]);
}
