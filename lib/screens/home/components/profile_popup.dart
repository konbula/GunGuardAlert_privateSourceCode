import 'package:flutter/material.dart';

class profile_popup extends StatelessWidget {
  final List<PopupMenuEntry> menulist;
  final Widget? icon;

  const profile_popup({super.key, required this.menulist, this.icon});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: ((context) => menulist),
      icon: icon,
      iconSize: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
