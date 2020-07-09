// Flutter imports:
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cgl/misc/progressIndicator.dart';
import 'package:cgl/misc/snackBar.dart';
import 'package:cgl/screens/home/page.dart';
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/family.dart';

class SetFamilyDialog extends StatefulWidget {
  _SetFamilyDialogState createState() => _SetFamilyDialogState();
}

class _SetFamilyDialogState extends State<SetFamilyDialog> {
  final createFamilyController = TextEditingController();
  final joinFamilyController = TextEditingController();

  listenToRequest() async {
    bool requestDialog = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCode = prefs.getString("countryCode");
    String mobileNumber = prefs.getString("mobileNumber");
    String user = (countryCode + ("-") + mobileNumber);
    Firestore.instance
        .collection("users")
        .document(user)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        if (doc.data.containsKey("request")) {
          requestDialog = true;
          showFamilyRequestDialog(context, doc.data["request"]);
        } else {
          if (requestDialog) {
            requestDialog = false;
            Navigator.of(context).pop();
          }
        }
      }
    });
  }

  listenToFamily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String countryCode = prefs.getString("countryCode");
    String mobileNumber = prefs.getString("mobileNumber");
    String user = (countryCode + ("-") + mobileNumber);
    Firestore.instance
        .collection("users")
        .document(user)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        if (doc.data.containsKey("family")) {
          prefs.setString('document', doc.data["family"]);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProvider(
                user: User(
                  mobileNumber,
                  countryCode,
                  prefs.getString("document"),
                  prefs.getString("token"),
                ),
                child: HomePage(),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void initState() {
    listenToRequest();
    listenToFamily();
    super.initState();
  }

  @override
  void dispose() {
    createFamilyController.dispose();
    joinFamilyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: primaryColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(24, 12, 0, 4),
                  child: Text(
                    createFamilyString,
                    style: appBarTitleStyle,
                  ),
                ),
                buildCreateFamily(),
                Center(
                  child: Text(
                    orString,
                    style: subTitleTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.fromLTRB(24, 12, 0, 4),
                  child: Text(
                    joinFamilyString,
                    style: appBarTitleStyle,
                  ),
                ),
                buildJoinFamily(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCreateFamily() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: createFamilyController,
                    keyboardType: TextInputType.text,
                    style: textStyle,
                    decoration: InputDecoration(
                      hintText: familyHintString,
                      hintStyle: hintTextStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: hintTextColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => RaisedButton(
                  color: whiteColor,
                  child: Icon(
                    Icons.done,
                    color: textColor,
                  ),
                  onPressed: () => checkCreateFamily(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkCreateFamily(BuildContext context) async {
    if (createFamilyController.text.length != 0) {
      joinFamilyController.text = "";
      showProgressIndicatorDialog(context);
      bool familyStatus = await createFamily(createFamilyController.text);
      if (!familyStatus) {
        showSnackBar(context, familyExistsString);
      }
      hideProgressIndicatorDialog(context);
    } else {
      showSnackBar(context, familyNameString);
    }
  }

  Container buildJoinFamily() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: joinFamilyController,
                    keyboardType: TextInputType.text,
                    style: textStyle,
                    decoration: InputDecoration(
                      hintText: familyHintString,
                      hintStyle: hintTextStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: hintTextColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: textColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) => RaisedButton(
                  color: whiteColor,
                  child: Icon(
                    Icons.arrow_forward,
                    color: textColor,
                  ),
                  onPressed: () => checkJoinFamily(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  checkJoinFamily(BuildContext context) async {
    if (joinFamilyController.text.length != 0) {
      createFamilyController.text = "";
      showProgressIndicatorDialog(context);
      bool familyStatus = await joinFamily(joinFamilyController.text);
      if (!familyStatus) {
        showSnackBar(context, familtNotExistsString);
      }
      hideProgressIndicatorDialog(context);
    } else {
      showSnackBar(context, familyNameString);
    }
  }
}

showFamilyRequestDialog(BuildContext context, String request) {
  cancelRequest(String familyName) {
    cancelFamilyRequest(familyName);
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Container(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Text(
                    "Awaiting Approval",
                    style: appBarTitleStyle,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "You have requested to join the ",
                    style: textStyle,
                    children: <TextSpan>[
                      TextSpan(
                        text: request,
                        style: appBarTitleStyle,
                      ),
                      TextSpan(
                        text: " family.\n\nYour potential family members have been notified of your join request.\n\n" +
                            "Join requests appear in the Family section of the app, kindly ask them to check their phone to speed up the process.\n\n",
                        style: textStyle,
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (context) => RaisedButton(
                      color: primaryColorDark,
                      child: Text(
                        "Cancel Request",
                        style: textStyle,
                      ),
                      onPressed: () => cancelRequest(request),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
