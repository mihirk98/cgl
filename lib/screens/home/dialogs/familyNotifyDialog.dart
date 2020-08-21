// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/screens/home/controller.dart';

class FamilyNotifyDialog extends StatefulWidget {
  final String mobileNumber, family;
  const FamilyNotifyDialog({
    Key key,
    @required this.mobileNumber,
    @required this.family,
  }) : super(key: key);
  @override
  _FamilyNotifyDialogState createState() =>
      _FamilyNotifyDialogState(mobileNumber, family);
}

class _FamilyNotifyDialogState extends State<FamilyNotifyDialog> {
  final String mobileNumber, family;
  _FamilyNotifyDialogState(this.mobileNumber, this.family);
  final notifyMessageTextController =
      TextEditingController(text: notifyMessageDefaultString);
  List<String> familyMembersList = [];
  List<bool> familyMembersNotifyStatusList = [];
  bool familyMembersExists;

  @override
  void dispose() {
    notifyMessageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    familyMembersExists = false;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      backgroundColor: secondaryColor,
      content: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
              color: secondaryColorDark,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    familyNotifyString,
                    style: appBarTitleStyle,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: textColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("lists")
                    .document(family)
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return showProgressIndicator();
                    default:
                      familyMembersList = (snapshot.data["family"])
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", "")
                          .split(", ");
                      for (int i = 0; i < familyMembersList.length; i++) {
                        familyMembersNotifyStatusList.add(true);
                      }
                      if (familyMembersList.length == 1) {
                        return Center(
                          child: Text(
                            noFamilyMembersString,
                            style: itemTextStyle,
                          ),
                        );
                      } else {
                        familyMembersExists = true;
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            for (int index = 0;
                                index < familyMembersList.length;
                                index++)
                              mobileNumber == familyMembersList[index]
                                  ? Container()
                                  : Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(
                                          12, 4, 12, 4),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8, 8, 0, 8),
                                                child: Text(
                                                  familyMembersList[index],
                                                  style: itemTextStyle,
                                                ),
                                              ),
                                              Theme(
                                                data: ThemeData(
                                                    unselectedWidgetColor:
                                                        primaryColor),
                                                child: Checkbox(
                                                  activeColor: primaryColorDark,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      familyMembersNotifyStatusList[
                                                          index] = value;
                                                    });
                                                  },
                                                  value:
                                                      familyMembersNotifyStatusList[
                                                          index],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                          ],
                        ),
                      );
                  }
                },
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
                      controller: notifyMessageTextController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 5,
                      style: textStyle,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: notifyMessageHintString,
                        hintStyle: hintTextStyle,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: hintTextColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: textColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          color: primaryColorDark,
                          child: Text(
                            notifyString,
                            style: itemTextStyle,
                          ),
                          onPressed: () => sendNotification(
                              familyMembersExists,
                              context,
                              familyMembersList,
                              familyMembersNotifyStatusList,
                              mobileNumber,
                              notifyMessageTextController.text),
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
    );
  }
}
