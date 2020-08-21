// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:cgl/constants/colors.dart';
import 'package:cgl/constants/strings.dart';
import 'package:cgl/constants/styles.dart';
import 'package:cgl/widgets/actionStatus.dart';
import 'package:cgl/widgets/internetStatus.dart';
import 'package:cgl/models/user.dart';
import 'package:cgl/providers/userProvider.dart';
import 'package:cgl/screens/family/controller.dart';
import 'package:cgl/screens/family/widgets/family.dart';
import 'package:cgl/screens/family/widgets/familyMembers.dart';

class FamilyPage extends StatelessWidget {
  final FamilyController controller = FamilyController();
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FamilyWidget(
                controller: controller,
                family: family,
                mobileNumber: mobileNumber),
            FamilyMembersWidget(family: family, mobileNumber: mobileNumber),
            ActionStatusWidget(),
            InternetStatusWidget(),
          ],
        ),
      ),
    );
  }
}
