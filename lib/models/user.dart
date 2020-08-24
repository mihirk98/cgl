// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cgl/widgets/snackBar.dart';
import 'package:cgl/constants/strings.dart';

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

  if (token != null) {
    bool tokenStatus =
        await checkToken(pref, token, countryCode + mobileNumber);
    if (tokenStatus) {
      token = pref.getString("token");
    }
  }

  return User(mobileNumber, countryCode, document, token);
}

Future<bool> createUser(
    BuildContext context, String dialCode, String mobileNumber) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = await notificationToken();
  bool returnValue;
  try {
    await Firestore.instance
        .collection("users")
        .document(dialCode + mobileNumber)
        .get()
        .then((doc) async => {
              if (doc.exists)
                {
                  await Firestore.instance
                      .collection("users")
                      .document(dialCode + mobileNumber)
                      .updateData(
                        {'token': token},
                      )
                      .then((_) => {
                            prefs.setString('mobileNumber', mobileNumber),
                            prefs.setString('countryCode', dialCode),
                            prefs.setString('token', token),
                            if (doc.data.containsKey("family"))
                              {
                                prefs.setString('document', doc.data["family"]),
                              },
                            returnValue = true,
                          })
                      .catchError((e) {
                        returnValue = false;
                        showSnackBar(context, errorString + e.toString(), 10);
                      }),
                }
              else
                {
                  await Firestore.instance
                      .collection("users")
                      .document(dialCode + mobileNumber)
                      .setData(
                        {'token': token},
                      )
                      .then((_) => {
                            prefs.setString('mobileNumber', mobileNumber),
                            prefs.setString('countryCode', dialCode),
                            prefs.setString('token', token),
                            returnValue = true,
                          })
                      .catchError((e) {
                        returnValue = false;
                        showSnackBar(context, errorString + e.toString(), 10);
                      }),
                }
            });
  } on PlatformException catch (e) {
    returnValue = false;
    showSnackBar(context, errorString + e.toString(), 10);
  }
  return returnValue;
}

Future<String> notificationToken() async {
  final FirebaseMessaging fcm = FirebaseMessaging();
  if (Platform.isIOS) {
    //ToDo IOS token upload
  } else {
    return await fcm.getToken();
  }
  return null;
}

Future<bool> checkToken(
    SharedPreferences pref, String token, String mobileNumber) async {
  bool returnValue = false;
  String tokenValue = await notificationToken();
  if (token != tokenValue) {
    Firestore.instance.collection("users").document(mobileNumber).updateData(
      {
        "token": tokenValue,
      },
    );
    pref.setString(
      "token",
      tokenValue,
    );
    returnValue = true;
  }
  return returnValue;
}
