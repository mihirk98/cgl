// Package imports:
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
  var db = Firestore.instance;
  var batch = db.batch();
  await db.collection("lists").document(familyName).get().then((doc) => {
        if (doc.exists)
          {
            batch.updateData(db.collection("lists").document(familyName), {
              'requests': FieldValue.arrayUnion([user])
            }),
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
