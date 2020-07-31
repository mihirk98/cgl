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
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
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
          showFamilyRequestDialog(context, scaffoldKey, doc.data["request"]);
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
        key: scaffoldKey,
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
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
              builder: (context) => Container(
                color: secondaryColor,
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.done,
                    color: textColor,
                  ),
                  onPressed: () => checkCreateFamily(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkCreateFamily(BuildContext context) async {
    if (createFamilyController.text.length != 0) {
      joinFamilyController.text = "";
      showProgressIndicatorDialog(context);
      bool familyStatus =
          await createFamily(createFamilyController.text.toLowerCase());
      if (!familyStatus) {
        showSnackBar(context, familyExistsString, 5);
      }
      hideProgressIndicatorDialog(context);
    } else {
      showSnackBar(context, familyNameString, 2);
    }
  }

  Container buildJoinFamily() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Card(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
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
              builder: (context) => Container(
                color: secondaryColor,
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: textColor,
                  ),
                  onPressed: () => checkJoinFamily(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkJoinFamily(BuildContext context) async {
    if (joinFamilyController.text.length != 0) {
      createFamilyController.text = "";
      showProgressIndicatorDialog(context);
      bool familyStatus =
          await joinFamily(joinFamilyController.text.toLowerCase());
      if (!familyStatus) {
        showSnackBar(context, familtNotExistsString, 5);
      }
      hideProgressIndicatorDialog(context);
    } else {
      showSnackBar(context, familyNameString, 2);
    }
  }
}

showFamilyRequestDialog(
    BuildContext contextScaffold, var scaffoldKey, String request) {
  showDialog(
    context: contextScaffold,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return FamilyRequestDialog(
        request: request,
        scaffoldKey: scaffoldKey,
      );
    },
  );
}

class FamilyRequestDialog extends StatefulWidget {
  final String request;
  final scaffoldKey;
  const FamilyRequestDialog(
      {Key key, @required this.request, @required this.scaffoldKey})
      : super(key: key);
  @override
  _FamilyRequestDialogState createState() =>
      _FamilyRequestDialogState(request, scaffoldKey);
}

class _FamilyRequestDialogState extends State<FamilyRequestDialog> {
  String request;
  var scaffoldKey;
  _FamilyRequestDialogState(this.request, this.scaffoldKey);
  final pinTextController = TextEditingController();
  String otpStatusText = "";
  bool otpStatusVisibility = false;

  @override
  void dispose() {
    pinTextController.dispose();
    super.dispose();
  }

  cancelRequest(String familyName) {
    cancelFamilyRequest(familyName);
  }

  verifyFamilyNameFunc(String familyName) {
    verifyFamilyRequest(pinTextController.text, familyName).then((status) => {
          setState(() {
            otpStatusVisibility = true;
            if (status == 0) {
              otpStatusText = otpVerificationSuccessString;
            } else if (status == 1) {
              otpStatusText = incorrectOTPString;
            } else if (status == 2) {
              otpStatusText = familtNotExistsString;
            }
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: AlertDialog(
        backgroundColor: secondaryColor,
        contentPadding: EdgeInsets.all(8),
        content: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: Text(
                    "Enter OTP",
                    style: appBarTitleStyle,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: <Widget>[
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
                                  text: " family.\n\n" +
                                      "A notification with the OTP has been sent to your family members.\n" +
                                      "If they do not see the notification, the OTP can be obtained from the family section of the " +
                                      appTitleString +
                                      " app.\n\n"
                                          "Contact your family members for the OTP and enter it below,\n",
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: TextField(
                    controller: pinTextController,
                    keyboardType: TextInputType.number,
                    style: itemTextStyle,
                    decoration: InputDecoration(
                      hintText: otpHintString,
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
                Visibility(
                  visible: otpStatusVisibility,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: Text(
                      otpStatusText,
                      style: appBarTitleStyle.apply(color: whiteColor),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      color: redColor,
                      child: Text(
                        cancelRequestString,
                        style: textStyle,
                      ),
                      onPressed: () => cancelRequest(request),
                    ),
                    RaisedButton(
                      color: primaryColorDark,
                      child: Text(
                        verifyOTPString,
                        style: textStyle,
                      ),
                      onPressed: () => verifyFamilyNameFunc(
                        request,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
