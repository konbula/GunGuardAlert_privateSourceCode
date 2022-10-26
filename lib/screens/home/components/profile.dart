import 'dart:developer';
import "package:guntrackattempt1/providers/address_provider.dart";
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/home/components/body.dart';

class profilePage extends StatefulWidget {
  profilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late TextEditingController _Adresscontroller;
  @override
  void initState() {
    super.initState();
    _Adresscontroller = TextEditingController();
  }

  @override
  void dispose() {
    _Adresscontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                iconSize: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.brown.shade800,
                child: const Icon(
                  Icons.person,
                  size: 50,
                ),
              )),
          const SizedBox(
            height: 50,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 4),
              child: Text(
                "Enter Home Address",
                style: TextStyle(
                    fontSize: 30, color: Color.fromARGB(255, 48, 47, 47)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 1,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(3.0),
            height: 70,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(34, 68, 137, 255)),
                color: Color.fromARGB(31, 86, 147, 253),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: TextField(
                controller: _Adresscontroller,
                onSubmitted: (String value) async {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) =>
                  //             Body(HomeAddress: value, initials: widget.initial)));
                  context.read<addressChange>().ChangeHomeAdress(value);
                  setState(() {
                    Body.HomeAddress = value;
                  });
                  Body.HomeAddress = value;
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Location inputed"),
                          content: Text(
                              "you typed '$value'. Your home marker will change in 5 to 25 seconds."),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        );
                      });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Your address is used to generate accurate measurements of gun activity in your area.\nIMPORTANT: No data in this app is tracked, or used in any way shape or form.  ",
                    style: TextStyle(
                        fontSize: 17, color: Color.fromARGB(255, 77, 74, 74)),
                  ),
                )
              ],
            ),
          )
        ])));
  }
}
