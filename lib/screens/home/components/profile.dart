import 'package:flutter/material.dart';

class profile extends StatelessWidget {
  profile({Key? key, required this.initial}) : super(key: key);
  String initial;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
                iconSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Align(
              alignment: Alignment.center,
              child: (initial == "")
                  ? CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.brown.shade800,
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      child: const Text("BK"),
                    )),
        ],
      )),
    );
  }
}
