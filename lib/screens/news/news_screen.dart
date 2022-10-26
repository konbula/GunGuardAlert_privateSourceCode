import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/home/components/aboutPage.dart';
import 'package:guntrackattempt1/screens/home/components/body.dart';
import 'package:guntrackattempt1/screens/home/components/profile.dart';
import 'package:guntrackattempt1/screens/home/components/profile_popup.dart';
import 'package:guntrackattempt1/screens/news/components/body.dart';
import 'package:guntrackattempt1/service/recent_api_service.dart';

class newsScreen extends StatefulWidget {
  const newsScreen({Key? key}) : super(key: key);

  @override
  State<newsScreen> createState() => _newsScreenState();
}

class _newsScreenState extends State<newsScreen> {
  ApiService client = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: Image.asset(
          //   'assets/images/GunGuardAlert.png',
          // ),
          // leadingWidth: 400,
          backgroundColor: BodyState.isSafe
              ? Colors.greenAccent
              : Color.fromARGB(255, 243, 89, 109),
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
        backgroundColor: Color.fromARGB(69, 157, 200, 245),
        body: NBody());
  }
}
