import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class HomeController {
  //Checked Visbility
  final checkedVisibilityStreamController = StreamController<bool>.broadcast();
  Stream<bool> get checkedVisibilityStream =>
      checkedVisibilityStreamController.stream;

  final checkedVisibilityUpdateStreamController = StreamController<bool>();
  Sink<bool> get checkedVisibilitySink =>
      checkedVisibilityUpdateStreamController.sink;
  Stream<bool> get checkedVisibilityUpdateStream =>
      checkedVisibilityUpdateStreamController.stream;

  //Quantity
  final quantityStreamController = StreamController<int>();
  Stream<int> get quantityStream => quantityStreamController.stream;

  final quantityUpdateStreamController = StreamController<int>();
  Sink<int> get quantitySink => quantityUpdateStreamController.sink;
  Stream<int> get quantityUpdateStream => quantityUpdateStreamController.stream;

  //Unit
  final unitStreamController = StreamController<String>();
  Stream<String> get unitStream => unitStreamController.stream;

  final unitUpdateStreamController = StreamController<String>();
  Sink<String> get unitSink => unitUpdateStreamController.sink;
  Stream<String> get unitUpdateStream => unitUpdateStreamController.stream;

  HomeController() {
    checkedVisibilityUpdateStream.listen((updatedVisibility) {
      checkedVisibilityStreamController.add(updatedVisibility);
    });
    quantityUpdateStream.listen((updatedQuantity) {
      quantityStreamController.add(updatedQuantity);
    });
    unitUpdateStream.listen((updatedUnit) {
      unitStreamController.add(updatedUnit);
    });
  }

  void dispose() {
    checkedVisibilityStreamController.close();
    checkedVisibilityUpdateStreamController.close();
    quantityStreamController.close();
    quantityUpdateStreamController.close();
    unitStreamController.close();
    unitUpdateStreamController.close();
  }
}

Future<bool> getCheckedVisibility() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  bool checkedVisbility = pref.getBool("checkedVisbility") ?? true;
  return checkedVisbility;
}

Future<void> setCheckedVisibility(bool visbilityValue) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("checkedVisbility", visbilityValue);
}
