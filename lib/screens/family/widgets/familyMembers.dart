import 'package:cgl/constants/styles.dart';
import 'package:cgl/misc/progressIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FamilyMembersWidget extends StatelessWidget {
  const FamilyMembersWidget({
    Key key,
    @required this.family,
    @required this.mobileNumber,
  }) : super(key: key);

  final String family, mobileNumber;

  @override
  Widget build(BuildContext context) {
    List<String> familyMembersList = [];
    return Expanded(
      child: StreamBuilder(
        stream:
            Firestore.instance.collection("lists").document(family).snapshots(),
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
              return Column(
                children: <Widget>[
                  for (String number in familyMembersList)
                    mobileNumber == number
                        ? Container()
                        : Container(
                            width: double.infinity,
                            margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 0, 16),
                                child: Text(
                                  number,
                                  style: itemTextStyle,
                                ),
                              ),
                            ),
                          ),
                ],
              );
          }
        },
      ),
    );
  }
}
