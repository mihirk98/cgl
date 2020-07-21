import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/family/widgets/family.dart';
import 'package:cgl/screens/family/widgets/familyMembers.dart';
import 'package:flutter/material.dart';

class FamilyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User userProvider = UserProvider.of(context);
    String family = userProvider.document;
    String mobileNumber =
        userProvider.countryCode + "-" + userProvider.mobileNumber;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text(
          familyString,
          style: appBarTitleStyle,
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: textColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          FamilyWidget(family: family, mobileNumber: mobileNumber),
          FamilyMembersWidget(family: family, mobileNumber: mobileNumber),
        ],
      ),
    );
  }
}
