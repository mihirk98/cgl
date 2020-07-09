// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cgl/main.dart';

class User {
  final String mobileNumber;
  final String countryCode;
  final String document;
  final String token;

  User(this.mobileNumber, this.countryCode, this.document, this.token);
}

Future<User> getUser() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  /*pref.setString("mobileNumber", null);
  pref.setString("countryCode", null);
  pref.setString("document", null);
  pref.setString("token", null);*/

  String mobileNumber = pref.getString("mobileNumber") ?? null;
  String countryCode = pref.getString("countryCode") ?? null;
  String document = pref.getString("document") ?? null;
  String token = pref.getString("token") ?? null;

  return User(mobileNumber, countryCode, document, token);
}

Future<void> createUser(
    BuildContext context, String dialCode, String mobileNumber) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = await notificationToken(mobileNumber);
  await Firestore.instance
      .collection("users")
      .document(dialCode + "-" + mobileNumber)
      .get()
      .then((doc) => {
            if (doc.exists)
              {
                Firestore.instance
                    .collection("users")
                    .document(dialCode + "-" + mobileNumber)
                    .updateData(
                  {'token': token},
                ),
                prefs.setString('mobileNumber', mobileNumber),
                prefs.setString('countryCode', dialCode),
                prefs.setString('token', token),
                if (doc.data.containsKey("family"))
                  {
                    prefs.setString('document', doc.data["family"]),
                  },
              }
            else
              {
                Firestore.instance
                    .collection("users")
                    .document(dialCode + "-" + mobileNumber)
                    .setData(
                  {'token': token},
                ),
                prefs.setString('mobileNumber', mobileNumber),
                prefs.setString('countryCode', dialCode),
                prefs.setString('token', token),
              }
          });
}
