// Package imports:
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> createFamily(String familyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String countryCode = prefs.getString("countryCode");
  String mobileNumber = prefs.getString("mobileNumber");
  String user = (countryCode + ("-") + mobileNumber);
  bool docStatus;
  var db = Firestore.instance;
  var batch = db.batch();
  await db.collection("lists").document(familyName).get().then((doc) => {
        if (!doc.exists)
          {
            batch.setData(db.collection("lists").document(familyName), {
              'family': FieldValue.arrayUnion([user])
            }),
            batch.updateData(
                db.collection("users").document(user), {"family": familyName}),
            batch.setData(
              db
                  .collection("lists")
                  .document(familyName)
                  .collection("items")
                  .document("Apple"),
              {
                'status': 0,
                'date': DateTime.now().millisecondsSinceEpoch,
                'quantity': 1,
                'unit': 'unit/s'
              },
            ),
            batch.commit(),
            prefs.setString('document', familyName),
            docStatus = true,
          }
        else
          {
            docStatus = false,
          }
      });
  return docStatus;
}

Future<bool> joinFamily(String familyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String countryCode = prefs.getString("countryCode");
  String mobileNumber = prefs.getString("mobileNumber");
  String user = (countryCode + ("-") + mobileNumber);
  bool docStatus;
  var random = new Random();
  int otp = random.nextInt(900000) + 100000;
  var db = Firestore.instance;
  var batch = db.batch();
  await db.collection("lists").document(familyName).get().then((doc) => {
        if (doc.exists)
          {
            batch.updateData(
              db.collection("lists").document(familyName),
              {
                'requests': FieldValue.arrayUnion(
                  [
                    user,
                  ],
                )
              },
            ),
            batch.updateData(
              db.collection("lists").document(familyName),
              {
                user: otp.toString(),
              },
            ),
            batch.updateData(
              db.collection("users").document(user),
              {
                'request': familyName,
              },
            ),
            batch.commit(),
            docStatus = true,
          }
        else
          {
            docStatus = false,
          }
      });
  return docStatus;
}

Future<void> cancelFamilyRequest(String familyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String countryCode = prefs.getString("countryCode");
  String mobileNumber = prefs.getString("mobileNumber");
  String user = (countryCode + ("-") + mobileNumber);
  var db = Firestore.instance;
  var batch = db.batch();
  await db.collection("lists").document(familyName).get().then((doc) => {
        if (doc.exists)
          {
            batch.updateData(db.collection("lists").document(familyName), {
              'requests': FieldValue.arrayRemove([user])
            }),
            batch.updateData(
              db.collection("lists").document(familyName),
              {
                user: FieldValue.delete(),
              },
            ),
            batch.updateData(
              db.collection("users").document(user),
              {
                'request': FieldValue.delete(),
              },
            ),
            batch.commit(),
          }
        else
          {
            db
                .collection("users")
                .document(user)
                .updateData({'request': FieldValue.delete()}),
          }
      });
}

Future<int> verifyFamilyRequest(String pin, String familyName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String countryCode = prefs.getString("countryCode");
  String mobileNumber = prefs.getString("mobileNumber");
  String user = (countryCode + ("-") + mobileNumber);
  int returnValue;
  var db = Firestore.instance;
  var batch = db.batch();
  if (pin.length == 6) {
    await db.collection("lists").document(familyName).get().then((doc) => {
          if (doc.exists)
            {
              if (doc.data[user] == pin)
                {
                  batch
                      .updateData(db.collection("lists").document(familyName), {
                    'requests': FieldValue.arrayRemove([user])
                  }),
                  batch
                      .updateData(db.collection("lists").document(familyName), {
                    'family': FieldValue.arrayUnion([user])
                  }),
                  batch.updateData(
                    db.collection("lists").document(familyName),
                    {
                      user: FieldValue.delete(),
                    },
                  ),
                  batch.updateData(
                    db.collection("users").document(user),
                    {
                      'request': FieldValue.delete(),
                    },
                  ),
                  batch.updateData(
                    db.collection("users").document(user),
                    {
                      'family': familyName,
                    },
                  ),
                  batch.commit(),
                  returnValue = 0,
                }
              else
                {
                  returnValue = 1,
                }
            }
          else
            {
              db
                  .collection("users")
                  .document(user)
                  .updateData({'request': FieldValue.delete()}),
              returnValue = 2,
            }
        });
  } else {
    returnValue = 1;
  }

  return returnValue;
}

Future<int> exitFamily(String family, String user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int returnValue;
  List<String> familyMembersList = [];
  var db = Firestore.instance;
  var batch = db.batch();
  await Firestore.instance
      .collection("lists")
      .document(family)
      .get()
      .then((doc) {
    if (doc.exists) {
      batch.updateData(
        db.collection("lists").document(family),
        {
          'family': FieldValue.arrayRemove([user])
        },
      );
      batch.updateData(
        db.collection("users").document(user),
        {
          'family': FieldValue.delete(),
        },
      );
      familyMembersList = doc["family"]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(", ");
      if (familyMembersList.length == 1) {
        batch.delete(db.collection("lists").document(family));
        batch.commit();
        returnValue = 2;
      } else {
        batch.commit();
        returnValue = 1;
      }
      prefs.setString('document', null);
    } else {
      batch.updateData(
        db.collection("users").document(user),
        {
          'family': FieldValue.delete(),
        },
      );
      batch.commit();
      prefs.setString('document', null);
      returnValue = 0;
    }
  });
  return returnValue;
}
