import 'package:flutter/material.dart';

class addressChange with ChangeNotifier {
  String _HomeAddressREAL = "1206 Sherwood rd Glenview Illinois 60025";
  String get HomeAddressREAL => _HomeAddressREAL;

  void ChangeHomeAdress(String newA) {
    _HomeAddressREAL = newA;
    notifyListeners();
  }

  String getHomeAddress() {
    return _HomeAddressREAL;
  }
}
