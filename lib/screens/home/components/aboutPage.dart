import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 222, 222, 241),
      body: SafeArea(
        child: Column(
          children: [
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
            SizedBox(
              height: 50,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "About Me",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 78, 76, 76)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 10),
                    child: Text(
                      "Hello! My name is Bryan Ko, the developer of the GunGuardAlert app! For some context about me, I am a 17 year old solo developer from Illinois.",
                      style: TextStyle(
                          fontSize: 19, color: Color.fromARGB(255, 82, 78, 78)),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Why This App?",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 78, 76, 76)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 10),
                    child: Text(
                      "I was inspired to make this app following the events of the July 4th Highland park mass shooting. Seeing the impact shootings have had on my communities, I aspire to provide citizens a way to stay notified of any firearm activity near them.",
                      style: TextStyle(
                          fontSize: 19, color: Color.fromARGB(255, 82, 78, 78)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
