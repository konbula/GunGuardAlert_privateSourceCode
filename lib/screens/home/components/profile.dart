import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/home/components/body.dart';

class profilePage extends StatefulWidget {
  profilePage({Key? key, required this.initial}) : super(key: key);
  String initial;
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
          child: (widget.initial == "")
              ? CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.brown.shade800,
                  child: const Icon(
                    Icons.person,
                    size: 50,
                  ),
                )
              : CircleAvatar(
                  radius: 60,
                  backgroundColor: Color.fromARGB(255, 146, 85, 71),
                  child: Text(
                    widget.initial,
                    style: TextStyle(fontSize: 50),
                  ),
                )),
      TextField(
        controller: _Adresscontroller,
        onSubmitted: (String value) async {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => Body(HomeAddress: value)));
          Body.HomeAddress = value;
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Location inputed"),
                  content: Text("you typed '$value'."),
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
    ])));
  }
}
