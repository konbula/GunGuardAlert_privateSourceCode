import 'package:flutter/material.dart';

class newsSearchBar extends StatefulWidget {
  const newsSearchBar({Key? key}) : super(key: key);

  @override
  State<newsSearchBar> createState() => _newsSearchBarState();
}

class _newsSearchBarState extends State<newsSearchBar> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      // Search Bar
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            blurRadius: 5,
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.13),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 198, 195, 195),
          prefixIcon: const Icon(Icons.search),
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
