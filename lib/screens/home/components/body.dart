import 'dart:async';
import 'dart:convert';
import 'package:guntrackattempt1/models/shooting_info_model.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

//all other imports
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
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
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

  String initials = "";

// maps functions and variables

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
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
  List RealnewAdresses = ["1206 sherwood rd glenview illinois"];

  void ChangeRealnewAdresses(List newThing) {
    setState(() {
      RealnewAdresses = newThing;
    });
  }

  void initState() {
    blarg = convertAddressToLatLonList(RealnewAdresses);
    reloadWebPagetimer = Timer.periodic(
        const Duration(seconds: 60), (Timer t) => reloadWebView());
    print(RealnewAdresses);

    super.initState();

    // List newAdresses() {
    //   var b = addShootings(Splitter(title!));
    //   List finalList = [];
    //   for (var i = 0; i < b.length; i++) {
    //     finalList
    //         .add(b[i].state + " " + b[i].cityOrCounty + " " + b[i].address);
    //   }
    //   return finalList;
    // }

    // convertAddressToLatLonList(newAdresses()).then((List result) {
    //   setState(() {
    //     RealnewAdresses = result;
    //   });
    // });
    // print(RealnewAdresses);
  }

  MapController? mapController;
  LatLng homePos = LatLng(42.07659479554499, -87.76737549957654);

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

              //print(RealnewAdresses);
            },
          ),
        ),
        body: SlidingUpPanel(
            panelBuilder: (sc) => PanelWidget(sc),
            //minHeight: 300,
            //maxHeight: 650,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            body: SafeArea(
                child: Expanded(
                    child: Stack(children: [
              title == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List>(
                      future: convertAddressToLatLonList(RealnewAdresses),
                      builder: ((context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        // return Text(snapshot.data
                        //     .toString()
                        //     .replaceAll(RegExp("\\[", unicode: true), "")
                        //     .replaceAll(RegExp("\\]", unicode: true), "")
                        //     .replaceAll(",", "")
                        //     .split(" ")[1]);

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

                        Future<List> convertedToLatLongList =
                            convertAddressToLatLonList(newAdresses());
                        List cheese = [];
                        void doSomething() async {
                          List blah = await convertedToLatLongList;
                          cheese.add(blah);
                          //debugPrint(cheese.toString());
                        }

                        doSomething();
                        doSomething();
                        debugPrint(snapshot.data.toString());
                        List<Marker> _getMarkers() {
                          List<Marker> markers = [];

                          //experiment

                          List blargList = snapshot.data
                              .toString()
                              .replaceAll(RegExp("\\[", unicode: true), "")
                              .replaceAll(RegExp("\\]", unicode: true), "")
                              .replaceAll(",", "")
                              .split(" ");

                          for (var x = 0; x < blargList.length; x++) {
                            if ((x % 2 == 0) &
                                (blargList.length > 1) &
                                blargList.length.isEven) {
                              markers.add(Marker(
                                  point: LatLng(double.parse(blargList[x]),
                                      double.parse(blargList[x + 1])),
                                  builder: ((context) => Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                      ))));
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
                                    color: Colors.blue,
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
                          Expanded(
                            child: FlutterMap(
                              mapController: mapController,
                              options: MapOptions(
                                  center: LatLng(42.077, -87.8223),
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
                                  markers: _getMarkers(),
                                ),
                                MarkerLayerOptions(
                                  markers: _getHomeMarker(),
                                ),
                                MarkerLayerOptions(
                                  markers: _getAreaMarkers(),
                                ),
                                CircleLayerOptions(circles: homeCircle()),
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
                          ),
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
                                              leading: const Icon(Icons.person),
                                              title: const Text("Profile"),
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => profilePage(
                                                    initial: initials,
                                                  ),
                                                ),
                                              ),
                                            )),
                                            const PopupMenuItem(
                                                child: ListTile(
                                              leading:
                                                  Icon(Icons.label_rounded),
                                              title: Text("Learn More"),
                                            )),
                                            const PopupMenuDivider(),
                                            const PopupMenuItem(
                                                child: ListTile(
                                              leading: Icon(Icons.info),
                                              title: Text("About"),
                                            )),
                                          ],
                                          icon: (initials == "")
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.brown.shade800,
                                                  child:
                                                      const Icon(Icons.person),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      Colors.brown.shade800,
                                                  child: const Text("BK"),
                                                ))
                                    ],
                                  ),
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
            height: 300,
            width: 300,
            child: Column(
              children: const [Text("STATUS")],
            ),
          ),
          //other things above
          Container(
            child: Column(
              children: [
                Text("Recent Activity"),
                // RealnewAdresses.length == 0
                //     ? ((calculateDistance(
                //                 double.parse(
                //                     convertAddressToLatLonList(RealnewAdresses)
                //                         .toString()
                //                         .replaceAll(
                //                             RegExp("\\[", unicode: true), "")
                //                         .replaceAll(
                //                             RegExp("\\]", unicode: true), "")
                //                         .replaceAll(",", "")
                //                         .split(" ")[0]),
                //                 double.parse(
                //                     convertAddressToLatLonList(RealnewAdresses)
                //                         .toString()
                //                         .replaceAll(
                //                             RegExp("\\[", unicode: true), "")
                //                         .replaceAll(
                //                             RegExp("\\]", unicode: true), "")
                //                         .replaceAll(",", "")
                //                         .split(" ")[1]),
                //                 homePos.latitude,
                //                 homePos.longitude) <=
                //             10)
                //         ? Text("there has been a shooting near" +
                //             RealnewAdresses[0])
                //         : const Text(""))
                //     : Text(""),
              ],
            ),
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
                  return Padding(
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
                          Text("${xShooting.state}, ${xShooting.cityOrCounty}",
                              overflow: TextOverflow.ellipsis,
                              style: (xShooting.state + xShooting.cityOrCounty)
                                          .length >
                                      20
                                  ? const TextStyle(fontSize: 15)
                                  : const TextStyle(fontSize: 18)),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ]);
}
