// Flutter imports:
import 'package:cgl/actionStatusSingleton.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:cgl/widgets/actionStatus.dart';
import 'package:cgl/widgets/internetStatus.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/widgets/snackBar.dart';
import 'package:cgl/screens/home/page.dart';
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/family.dart';

ActionStatusSingleton actionStatus = ActionStatusSingleton.getInstance();

bool joinFamilyLoadingDialog = false;

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
    String user = (countryCode + mobileNumber);
    Firestore.instance
        .collection("users")
        .document(user)
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        if (doc.data.containsKey("request")) {
          requestDialog = true;
          if (joinFamilyLoadingDialog) {
            hideProgressIndicatorDialog(context);
            joinFamilyLoadingDialog = false;
          }
          showFamilyRequestDialog(context, scaffoldKey, doc.data["request"]);
          print("showFamilyRequestDialog");
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
    String user = (countryCode + mobileNumber);
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ActionStatusWidget(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(24, 24, 0, 4),
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: primaryColorLight,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(24),
                          margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: RichText(
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: familyFAQ1String,
                                style: itemTextStyle.copyWith(fontSize: 30),
                              ),
                              TextSpan(text: "\n\n"),
                              TextSpan(
                                text: familyFAQ2String,
                                style: itemTextStyle.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: "\n"),
                              TextSpan(
                                text: familyFAQ3String,
                              ),
                              TextSpan(text: "\n\n"),
                              TextSpan(text: " - "),
                              TextSpan(
                                text: familyFAQ4String,
                                style: itemTextStyle
                                    .copyWith(fontWeight: FontWeight.w900)
                                    .apply(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: familyFAQ5String,
                              ),
                              TextSpan(text: "\n\n"),
                              TextSpan(text: " - "),
                              TextSpan(
                                text: familyFAQ6String,
                                style: itemTextStyle
                                    .copyWith(fontWeight: FontWeight.w900)
                                    .apply(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: familyFAQ7String,
                              ),
                              TextSpan(text: "\n\n"),
                              TextSpan(text: " - "),
                              TextSpan(
                                text: familyFAQ8String,
                                style: itemTextStyle
                                    .copyWith(fontWeight: FontWeight.w900)
                                    .apply(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: familyFAQ9String,
                              ),
                              TextSpan(text: "\n\n"),
                              TextSpan(text: " - "),
                              TextSpan(
                                text: familyFAQ10String,
                                style: itemTextStyle
                                    .copyWith(fontWeight: FontWeight.w900)
                                    .apply(
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: familyFAQ11String,
                              ),
                            ], style: itemTextStyle),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InternetStatusWidget(),
            ],
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
      String familyStatus =
          await createFamily(createFamilyController.text.toLowerCase());
      if (familyStatus == "0") {
        hideProgressIndicatorDialog(context);
        showSnackBar(context, familyExistsString, 5);
      } else if (familyStatus != "1") {
        hideProgressIndicatorDialog(context);
        showSnackBar(context, familyStatus, 5);
      }
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
      joinFamilyLoadingDialog = true;
      bool familyStatus =
          await joinFamily(joinFamilyController.text.toLowerCase());
      if (!familyStatus) {
        showSnackBar(context, familtNotExistsString, 5);
      }
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
            } else if (status == 3) {
              otpStatusText = failureString;
            }
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => null,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(0),
        backgroundColor: secondaryColor,
        content: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(16),
                color: secondaryColorDark,
                child: Text(
                  enterCodeTitleString,
                  style: appBarTitleStyle,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: familyJoinRequestString1 + " ",
                        style: textStyle,
                        children: <TextSpan>[
                          TextSpan(
                            text: request + " ",
                            style: appBarTitleStyle,
                          ),
                          TextSpan(
                              text: familyJoinRequestString2 + " \n\n",
                              style: textStyle),
                          TextSpan(
                              text: familyJoinRequestString3 + "\n\n",
                              style: appBarTitleStyle),
                          TextSpan(
                            text: familyJoinRequestString4 +
                                " " +
                                appTitleString +
                                " " +
                                familyJoinRequestString5 +
                                " \n\n",
                            style: textStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: secondaryColorLight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: TextField(
                        controller: pinTextController,
                        keyboardType: TextInputType.number,
                        style: itemTextStyle,
                        decoration: InputDecoration(
                          hintText: codeHintString,
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
                          style: itemTextStyle.apply(color: redColor),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: redColor,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Text(
                              cancelRequestString,
                              maxLines: 5,
                              style: textStyle,
                            ),
                            onPressed: () => cancelRequest(request),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            color: primaryColorDark,
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            child: Text(
                              verifyOTPString,
                              maxLines: 5,
                              style: textStyle,
                            ),
                            onPressed: () => verifyFamilyNameFunc(
                              request,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
