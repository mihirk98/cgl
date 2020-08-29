// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:cgl/constants/styles.dart';
import 'package:cgl/widgets/progressIndicator.dart';
import 'package:cgl/constants/strings.dart';

class FamilyMembersWidget extends StatelessWidget {
  const FamilyMembersWidget({
    Key key,
    @required this.family,
    @required this.mobileNumber,
  }) : super(key: key);

  final String family, mobileNumber;

  @override
  Widget build(BuildContext context) {
    List<String> familyMembersList, requestsList = [];
    if (family != null) {
      return Expanded(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection("lists")
              .document(family)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return showProgressIndicator();
                default:
                  familyMembersList = (snapshot.data["family"])
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .split(", ");
                  requestsList = (snapshot.data["requests"])
                      .toString()
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .split(", ");
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        requestsList.toString() == "[null]" ||
                                requestsList.toString() == "[]"
                            ? Container()
                            : Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 20, 8),
                                    child: Text(
                                      requestString,
                                      style: titleTextStyle,
                                    ),
                                  ),
                                  for (String request in requestsList)
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(
                                          12, 4, 12, 4),
                                      child: Card(
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 16, 0, 16),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 4),
                                                child: Text(
                                                  request,
                                                  style: itemTextStyle,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  codeString +
                                                      snapshot.data[request],
                                                  style: subTitleTextStyle,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                        familyMembersList.length == 1
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 20, 8),
                                    child: Text(
                                      membersSting,
                                      style: titleTextStyle,
                                    ),
                                  ),
                                  for (String number in familyMembersList)
                                    mobileNumber == number
                                        ? Container()
                                        : Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.fromLTRB(
                                                12, 4, 12, 4),
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        16, 16, 0, 16),
                                                child: Text(
                                                  number,
                                                  style: itemTextStyle,
                                                ),
                                              ),
                                            ),
                                          ),
                                ],
                              ),
                      ],
                    ),
                  );
              }
            } else {
              return Container();
            }
          },
        ),
      );
    } else {
      return Expanded(
        child: Container(),
      );
    }
  }
}
