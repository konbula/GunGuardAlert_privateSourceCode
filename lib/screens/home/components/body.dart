import 'dart:async';
import 'dart:convert';
import 'package:guntrackattempt1/models/shooting_info_model.dart';
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

//all other imports
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  void getWebsiteData(String rawHtml) {
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
  static const initialCameraPos = CameraPosition(
      target: LatLng(42.097070344947255, -87.72017223705998), zoom: 11.5);

  GoogleMapController? gmController;
  final adressStoreController = TextEditingController();
  void dispose() {
    adressStoreController.dispose();
    gmController?.dispose();
    timer?.cancel();
    super.dispose();
  }

  void addMarker(LatLng pos) {}
  String initials = "";

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
              getWebsiteData(json.decode(html!));
            },
          ),
        ),
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
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => profile(
                                            initial: initials,
                                          ),
                                        ),
                                      ),
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

  Timer? timer;
  void reloadWebView() {
    wvController?.reload();
  }

  void initState() {
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => reloadWebView());
  }

  Widget PanelWidget(ScrollController sc) => title == null
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          controller: sc,
          itemCount: addShootings(Splitter(title!)).length,
          itemBuilder: (BuildContext context, int index) {
            var a = addShootings(Splitter(title!));
            shooting xShooting = a[index];
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 10),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(xShooting.incidentDate),
                    SizedBox(
                      width: 10,
                    ),
                    Text(xShooting.state),
                    SizedBox(
                      width: 10,
                    ),
                    Text(xShooting.cityOrCounty),
                    SizedBox(
                      width: 10,
                    ),
                    Text(xShooting.address),
                    SizedBox(
                      width: 10,
                    ),
                    Text(xShooting.injured),
                    SizedBox(
                      width: 10,
                    ),
                    Text(xShooting.killed),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            );
          });
}
