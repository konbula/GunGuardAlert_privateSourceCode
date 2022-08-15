import 'package:flutter/material.dart';
import 'package:guntrackattempt1/screens/home/home_screen.dart';
import 'package:guntrackattempt1/screens/data/data_screen.dart';


// class CustomBottomNavBar extends StatelessWidget {
//   CustomBottomNavBar({
//     Key? key,
//     required this.selectedMenu,
//   }) : super(key: key);

//   final MenuState selectedMenu;
//   int _currentTab = 1;
//   @override
//   Widget build(BuildContext context) {
//     final Color inActiveIconColor = Color(0xFFB6B6B6);
//     return BottomNavigationBar(
//         currentIndex: _currentTab,
//         onTap: (int value) {
//           setState(() {
//             _currentTab = value;
//             if (value == 1) {
//               Navigator.pushNamed(context, HomeScreen.routeName);
//             }
//             if (value == 0) {
//               Navigator.pushNamed(context, dataScreen.routeName);
//             }
//           });
//         },
//         type: BottomNavigationBarType.fixed,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.pie_chart),
//             label: 'Data',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_rounded),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.newspaper),
//             label: 'News',
//           ),
//         ],
//       )
//   }
// }
