import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item {
  final String name;
  final int date;
  final int status;
  final int quantity;

  Item(this.name, this.date, this.status, this.quantity);
}

Future<void> setItemStatus(
    BuildContext context, String item, bool status) async {
  User userProvider = UserProvider.of(context);
  String family = userProvider.document;
  int itemStatus;
  if (status) {
    itemStatus = 0;
  } else {
    itemStatus = 1;
  }
  Firestore.instance
      .collection("lists")
      .document(family)
      .collection("items")
      .document(item)
      .updateData(
    {
      'status': itemStatus,
      'date': DateTime.now().millisecondsSinceEpoch,
    },
  );
}

Future<void> addItem(BuildContext context, String item) async {
  User userProvider = UserProvider.of(context);
  String family = userProvider.document;
  Firestore.instance
      .collection("lists")
      .document(family)
      .collection("items")
      .document(item)
      .setData(
    {
      'status': 0,
      'date': DateTime.now().millisecondsSinceEpoch,
      'quantity': 1,
    },
  );
}
