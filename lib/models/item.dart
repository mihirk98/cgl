// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';

class Item {
  final String name;
  final int date;
  final int status;
  final int quantity;
  final String unit;

  Item(this.name, this.date, this.status, this.quantity, this.unit);
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

Future<void> addItem(
    BuildContext context, String item, int quantity, String unit) async {
  if (item.length != 0) {
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
        'quantity': quantity,
        'unit': unit,
      },
    );
  }
}

Future<void> deleteItem(String family, String item) async {
  Firestore.instance
      .collection("lists")
      .document(family)
      .collection("items")
      .document(item)
      .delete();
}

Future<void> editQuantity(
    String family, String item, int quantity, String unit) async {
  Firestore.instance
      .collection("lists")
      .document(family)
      .collection("items")
      .document(item)
      .updateData(
    {
      'quantity': quantity,
      'unit': unit,
    },
  );
}

Future<void> replaceItem(String family, String oldItem, String newItem,
    int quantity, bool status, String unit) async {
  int statusInt;
  if (status) {
    statusInt = 1;
  } else {
    statusInt = 0;
  }
  var db = Firestore.instance;
  var batch = db.batch();
  batch.delete(
    db
        .collection("lists")
        .document(family)
        .collection("items")
        .document(oldItem),
  );
  batch.setData(
    db
        .collection("lists")
        .document(family)
        .collection("items")
        .document(newItem),
    {
      'quantity': quantity,
      'status': statusInt,
      'date': DateTime.now().millisecondsSinceEpoch,
      'unit': unit,
    },
  );
  batch.commit();
}

Future<int> backUpItems(String family, String user) async {
  var db = Firestore.instance;
  var batch = db.batch();
  await db
      .collection("lists")
      .document(family)
      .collection("items")
      .getDocuments()
      .then(
        (snapshot) => {
          for (var itemData in snapshot.documents)
            {
              batch.setData(
                db
                    .collection("users")
                    .document(user)
                    .collection("items")
                    .document(itemData.documentID),
                {
                  'status': itemData["status"],
                  'date': itemData["date"],
                  'quantity': itemData["quantity"],
                  'unit': itemData["unit"],
                },
              ),
            },
          batch.commit(),
        },
      );
  return 1;
}

Future<void> getBackedUpItems(String family, String user) async {
  var db = Firestore.instance;
  var batch = db.batch();
  await db
      .collection("users")
      .document(user)
      .collection("items")
      .getDocuments()
      .then(
        (snapshot) async => {
          for (var itemData in snapshot.documents)
            {
              await db
                  .collection("lists")
                  .document(family)
                  .collection("items")
                  .document(itemData.documentID)
                  .get()
                  .then((doc) => {
                        if (!doc.exists)
                          {
                            batch.setData(
                              db
                                  .collection("lists")
                                  .document(family)
                                  .collection("items")
                                  .document(itemData.documentID),
                              {
                                'status': itemData["status"],
                                'date': DateTime.now().millisecondsSinceEpoch,
                                'quantity': itemData["quantity"],
                                'unit': itemData["unit"],
                              },
                            ),
                          }
                      }),
              batch.delete(db
                  .collection("users")
                  .document(user)
                  .collection("items")
                  .document(itemData.documentID)),
            },
          batch.commit(),
        },
      );
}
